FROM node:20-alpine

RUN apk add --no-cache curl

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY . .

EXPOSE 3000

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s --retries=5 CMD curl --fail http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
