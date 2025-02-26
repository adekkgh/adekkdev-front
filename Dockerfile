# Используем официальный Node.js образ
FROM node:18

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json и конфигурационные файлы
COPY package*.json ./
COPY svelte.config.js tsconfig.json vite.config.ts ./

# Устанавливаем зависимости
RUN npm install
ENV PATH="./node_modules/.bin:$PATH"

# Копируем остальные файлы проекта
COPY . .

# Собираем проект (опционально для продакшн)
RUN npm run build

# Открываем порт 3000
EXPOSE 3000

CMD ["vite", "--host", "--port", "3000"]