<script>
    import { onMount } from 'svelte';
    let result = '⏳ Проверка...';

    onMount(() => {
        if (!window.ApplePaySession || !ApplePaySession.canMakePayments()) {
            result = '❌ Apple Pay недоступен на этом устройстве или браузере.';
            return;
        }

        try {
            const request = {
                countryCode: 'RU',
                currencyCode: 'RUB',
                supportedNetworks: ['visa', 'masterCard', 'mir'],
                merchantCapabilities: ['supports3DS'],
                total: {
                    label: 'Тестовая покупка',
                    amount: '1.00',
                },
                merchantIdentifier: 'adekkdev.com.fake-mst',
            };

            const session = new ApplePaySession(3, request);

            session.onvalidatemerchant = (event) => {
                console.log('✅ onvalidatemerchant вызван!');
                console.log('validationURL:', event.validationURL);
                result = '✅ Вызван onvalidatemerchant — домен зарегистрирован!';
                session.abort(); // мы не продолжаем оплату, просто тестируем
            };

            session.oncancel = () => {
                console.log('🛑 Пользователь отменил платеж');
            };

            session.onerror = (err) => {
                console.error('❌ Ошибка в Apple Pay:', err);
                result = '❌ Ошибка в Apple Pay: ' + err.message;
            };

            session.begin();
        } catch (err) {
            console.error('❌ Ошибка при инициализации:', err);
            result = '❌ Инициализация не удалась: ' + err.message;
        }
    });
</script>

<h1 class="text-xl font-bold mb-4">Проверка Apple Pay</h1>
<p>{result}</p>