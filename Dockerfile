FROM node:20-bullseye

# Install python for static server
RUN apt-get update && apt-get install -y python3 python3-pip curl gnupg && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY . /workspace

RUN npm ci
RUN npx playwright install --with-deps

EXPOSE 3000

CMD ["/bin/bash","-lc","./setup.sh && ./run.sh && npx playwright test --reporter=list"]
