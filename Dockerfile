FROM node:20-bullseye

# Install Python3 and curl for the dev server and healthchecks
RUN apt-get update && apt-get install -y python3 curl ca-certificates git && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Copy project files
COPY package.json package-lock.json* ./
COPY . ./

# Install deps and Playwright browsers
RUN npm ci
RUN npx playwright install --with-deps

# Expose the server port
EXPOSE 3000

# Run tests (setup and test scripts included)
CMD ["/bin/bash", "-lc", "./test.sh"]
