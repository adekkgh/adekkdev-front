<script lang="ts">
    import {onMount} from "svelte";

    let pageTitle: HTMLHeadingElement;
    let pageSubtitle: HTMLHeadingElement;

    onMount(() => {
        animateTitles();
    });

    // simulating typing effect on titles
    function animateTitles() {
        const completeTitle = 'ADEK';
        const completeSubtitle = 'work in progress';

        for (let i = 0; i < completeTitle.length; i++) {
            setTimeout(() => {
                pageTitle.textContent += completeTitle[i];
            }, i * 150);
        }

        setTimeout(() => {
            let subtitleDelay = 0;

            for (let i = 0; i < completeSubtitle.length; i++) {
                const rndInterval = Number((Math.random() * 2).toFixed(2));
                subtitleDelay += rndInterval * 100;
                setTimeout(() => {
                    pageSubtitle.textContent += completeSubtitle[i];
                }, subtitleDelay, i);
            }
        }, 600);
    }
</script>

<div class="temp-div">
    <h1
        class="temp-div__title"
        bind:this={pageTitle}
    >
        {''}
    </h1>
    <h4
        class="temp-div__subtitle"
        bind:this={pageSubtitle}
    >
        {''}
    </h4>
</div>

<style lang="scss">
    .temp-div {
      display: flex;
      flex-direction: column;
      gap: 12px;

      &__title {
        text-align: center;
        letter-spacing: 5px;
        font-size: 64px;
      }

      &__subtitle {
        text-align: center;
        letter-spacing: 2px;
      }
    }
</style>