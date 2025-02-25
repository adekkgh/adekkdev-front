# Используем официальный Node.js образ
FROM node:20

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы проекта
COPY . .

# Собираем проект (опционально для продакшн)
RUN npm run build

# Открываем порт 3000
EXPOSE 3000

# Запускаем сервер разработки (для dev) или продакшн сервер
CMD ["npm", "run", "dev", "--", "--host"]
