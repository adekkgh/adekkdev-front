<script>
    import { onMount } from 'svelte';

    let showPayform = false;
    let payformURL = '';

    async function handleButtonClick() {
        showPayform = !showPayform;

        const script = document.createElement('script');
        script.src = 'https://pay.dev.simbasoft.com/widget/payform.js';
        script.charset = 'utf-8';
        script.id = 'psp-widget-loader';

        script.onload = () => {
            // Инициализация виджета после загрузки скрипта
            window.PSP.Widget.init({
                display: {
                    mode: "modal",
                    theme: {
                        name: "default",
                    }
                },
                payUrl: payformURL,
            });
        };

        document.head.appendChild(script);
    }
</script>

<!-- Контейнер для виджета -->
<div id="mywidget"></div>

{#if showPayform}
    <div id="mywidget"></div>
{:else}
    <div class="testik">
        <input type="text" placeholder="payform URL" bind:value={payformURL}>
        <button
            on:click={async () => await handleButtonClick()}
        >
            Open payform
        </button>
    </div>
{/if}

<style lang="scss">
    .testik {
      width: max-content;
      margin: 200px auto;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;

      & input {
        width: 400px;
      }

      & button {
        width: 150px;
      }
    }
</style>