# Базовий образ з Node.js
FROM node:20-alpine

# Робоча директорія всередині контейнера
WORKDIR /app

# Копіюємо package.json і package-lock.json (щоб кешувати встановлення залежностей)
COPY package*.json ./

# Встановлюємо тільки production-залежності
RUN npm install --production

# Копіюємо решту файлів (включно з public/, server.js, data.json)
COPY . .

# Контейнер слухає на порту 3000
EXPOSE 3000

# Add a healthcheck endpoint with curl
HEALTHCHECK --interval=10s --timeout=3s --retries=5 CMD curl --fail http://localhost:3000/health || exit 1

# Запуск додатку
CMD ["node", "server.js"]
