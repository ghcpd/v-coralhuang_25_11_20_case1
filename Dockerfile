FROM node:20-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip curl ca-certificates gnupg2 procps lsof \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . .

RUN if [ -f package-lock.json ]; then npm ci --no-audit --progress=false; else npm install --no-audit --progress=false; fi || true
RUN npx playwright install --with-deps || npx playwright install

CMD ["/bin/bash","-lc","bash test.sh"]
