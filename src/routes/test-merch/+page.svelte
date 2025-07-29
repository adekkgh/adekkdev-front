<script>
    let result = 'Нажмите кнопку для проверки Apple Pay';

    function checkApplePay() {
        if (!window.ApplePaySession || !ApplePaySession.canMakePayments()) {
            result = '❌ Apple Pay недоступен на этом устройстве.';
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
                merchantIdentifier: 'adekkdevtesttest.ru.fake-mst',
            };

            const session = new ApplePaySession(3, request);

            session.onvalidatemerchant = (event) => {
                console.log('✅ Вызван onvalidatemerchant');
                result = '✅ Домен зарегистрирован, сессия инициирована!';
                session.abort();
            };

            session.onerror = (err) => {
                console.error('❌ Ошибка Apple Pay:', err);
                result = '❌ Ошибка: ' + err.message;
            };

            session.begin();
        } catch (err) {
            console.error('❌ Инициализация не удалась:', err);
            result = '❌ Инициализация не удалась: ' + err.message;
        }
    }
</script>

<h1 class="text-xl font-bold mb-4">Проверка Apple Pay</h1>
<p class="mb-4">{result}</p>
<button class="bg-black text-white px-4 py-2 rounded" on:click={checkApplePay}>
    Проверить Apple Pay
</button>
