# 🛠️ Этап 1: Установка зависимостей и сборка
FROM node:18 AS builder

WORKDIR /app

# Копируем package.json и package-lock.json для кеширования npm install
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

# Собираем проект (нужно для production, можно пропустить для dev)
RUN npm run build

# 🚀 Этап 2: Запуск приложения
FROM node:18

WORKDIR /app

# Копируем только собранный проект и node_modules из builder
COPY --from=builder /app /app
COPY --from=builder /app/node_modules /app/node_modules

# Открываем порт для Vite
EXPOSE 3000

# Используем npm run dev для разработки
CMD ["npm", "run", "dev", "--", "--host", "--port", "3000"]
