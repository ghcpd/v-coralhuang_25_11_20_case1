FROM node:18-bullseye

# Install Python 3 and required tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    lsof \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json* ./

# Install Node dependencies
RUN npm install

# Install Playwright browsers and dependencies
RUN npx playwright install --with-deps chromium

# Copy application files
COPY . .

# Expose port 3000
EXPOSE 3000

# Run tests
CMD ["bash", "test.sh"]
