<script lang="ts">
    import { onMount } from 'svelte';
    import * as THREE from 'three';
    import { GLTFLoader } from 'three/examples/jsm/Addons.js';

    let canvas: HTMLCanvasElement;
    let scene: THREE.Scene;
    let camera: THREE.PerspectiveCamera;
    let renderer: THREE.WebGLRenderer;
    let model: THREE.Object3D;
    let mouseInside = true;

    onMount(() => {
        scene = new THREE.Scene();
        camera = new THREE.PerspectiveCamera(15, 1, 0.1, 1000);
        camera.position.z = 5;

        renderer = new THREE.WebGLRenderer({ canvas, alpha: true, antialias: true });
        renderer.setSize(800, 800);
        renderer.setPixelRatio(window.devicePixelRatio);
        renderer.setClearColor(0x000000, 0);

        // Мягкий рассеянный свет (общий фон)
        const ambientLight = new THREE.AmbientLight(0xffffff, 1);
        scene.add(ambientLight);

        // Направленный свет (как солнце)
        const directionalLight = new THREE.DirectionalLight(0xffffff, 1.5);
        directionalLight.position.set(5, 10, 5);
        directionalLight.castShadow = true;
        scene.add(directionalLight);

        // (По желанию) Точки подсветки сбоку
        const keyLight = new THREE.PointLight(0xffffff, 0.4);
        keyLight.position.set(-5, 5, 5);
        scene.add(keyLight);

        const loader = new GLTFLoader();
        loader.load('/models/king-bob.glb', (gltf) => {
            model = gltf.scene;
            model.scale.set(0.2, 0.2, 0.2);
            model.position.y = -0.8;
            scene.add(model);

            const leftPupil = model.getObjectByName('Eyes_L');
            const rightPupil = model.getObjectByName('Eyes_R');

            if (!leftPupil || !rightPupil) {
                console.error('Зрачки не найдены!');
                return;
            }

            const leftInitPos = leftPupil.position.clone();
            const rightInitPos = rightPupil.position.clone();
            const leftTargetPos = leftInitPos.clone();
            const rightTargetPos = rightInitPos.clone();

            window.addEventListener('mousemove', (event) => {
                const rect = canvas.getBoundingClientRect();
                const mouseX = ((event.clientX - rect.left) / rect.width) * 2 - 1;
                const mouseY = -((event.clientY - rect.top) / rect.height) * 2 + 1;

                const maxHorizontal = 0.1;
                const maxVertical = 0.1;

                // Обновляем целевую позицию (без резких движений)
                leftTargetPos.x = leftInitPos.x + mouseX * maxHorizontal;
                leftTargetPos.y = leftInitPos.y * 10;
                leftTargetPos.z = leftInitPos.z + mouseY * maxVertical;

                rightTargetPos.x = rightInitPos.x + mouseX * maxHorizontal;
                rightTargetPos.y = rightInitPos.y * 10;
                rightTargetPos.z = rightInitPos.z + mouseY * maxVertical;
            });

            const animate = () => {
                requestAnimationFrame(animate);

                const lerpFactor = 0.05; // Чем меньше — тем плавнее
                if (!mouseInside) {
                    leftTargetPos.copy(leftInitPos);
                    rightTargetPos.copy(rightInitPos);
                }

                // Плавно двигаем зрачки к целевой позиции
                leftPupil.position.lerp(leftTargetPos, lerpFactor);
                rightPupil.position.lerp(rightTargetPos, lerpFactor);

                renderer.render(scene, camera);
            };
            animate();
        });

        document.addEventListener('mouseenter', () => {
            mouseInside = true;
        });

        document.addEventListener('mouseleave', () => {
            mouseInside = false;
        });

        const handleResize = () => {
            if (!canvas) return;
            const width = canvas.clientWidth;
            const height = canvas.clientHeight;
            camera.aspect = width / height;
            camera.updateProjectionMatrix();
            renderer.setSize(width, height);
        };

        window.addEventListener('resize', handleResize);

        return () => {
            window.removeEventListener('resize', handleResize);
            renderer.dispose();
        };
    });
</script>

<canvas bind:this={canvas} />

<style>
    canvas {
        width: 100%;
        height: 100%;
        display: block;
        background: transparent;
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translate(-50%, 0);
    }
</style>
