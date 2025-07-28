<script>
    import { onMount } from 'svelte';

    onMount(async () => {
        // Динамически загружаем скрипт
        const script = document.createElement('script');
        script.src = 'https://pay.dev.simbasoft.com/widget/payform.js';
        script.charset = 'utf-8';
        script.id = 'psp-widget-loader';

        script.onload = () => {
            // Инициализация виджета после загрузки скрипта
            window.PSP.Widget.init({
                display: {
                    mode: "modal",
                    options: {
                        container: "mywidget",
                        pcidss: "full",
                    },
                    theme: {
                        name: "dark",
                        colors: {
                            bg: "#4a5b5b",
                            primary: "#313337",
                            secondary: "#009D8C",
                            info: "#fff",
                            label: "#fff",
                            danger: "#FF592C",
                            success: "#17BD98",
                            inactive: "#fff"
                        }
                    }
                },
                payUrl: 'https://pay.dev.simbasoft.com/?token=EWBWkWCaxG8'
            });
        };

        document.head.appendChild(script);

        // Очистка при размонтировании компонента
        return () => {
            if (document.getElementById('psp-widget-loader')) {
                document.head.removeChild(script);
            }
        };
    });
</script>

<!-- Контейнер для виджета -->
<div id="mywidget"></div>