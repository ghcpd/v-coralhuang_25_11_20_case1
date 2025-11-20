FROM mcr.microsoft.com/playwright:focal:latest

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN chmod +x setup.sh run.sh test.sh
RUN npx playwright install --with-deps chromium

CMD ["./test.sh"]
