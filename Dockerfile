# Базовий образ з Node.js
FROM node:20-alpine

# Встановлюємо curl для healthcheck
RUN apk add --no-cache curl

# Робоча директорія всередині контейнера
WORKDIR /app

# Копіюємо package.json і package-lock.json (щоб кешувати встановлення залежностей)
COPY package*.json ./

# Встановлюємо тільки production-залежності
RUN npm install --production

# Копіюємо решту файлів (public/, server.js, data.json)
COPY . .

# Контейнер слухає на порту 3000
EXPOSE 3000

# Додаємо healthcheck endpoint
HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=5 CMD curl --fail http://localhost:3000/health || exit 1

# Запуск додатку
CMD ["node", "server.js"]
