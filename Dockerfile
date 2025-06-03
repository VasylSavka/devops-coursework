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

# Healthcheck для Docker (для продакшну)
HEALTHCHECK --interval=30s --timeout=5s CMD wget --spider http://localhost:3000/health || exit 1

# Запуск додатку
CMD ["node", "server.js"]
