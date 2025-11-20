FROM node:20-bullseye

# Install python3, curl and playwright dependencies
RUN apt-get update && apt-get install -y \
	python3 python3-venv python3-pip \
	curl ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Node deps first for better caching
COPY package*.json ./
COPY tsconfig.json ./
RUN npm install
RUN npx playwright install --with-deps

# Copy the rest of the project
COPY . .

RUN chmod +x setup.sh run.sh test.sh

EXPOSE 3000

# Default to running the automated tests
CMD ["./test.sh"]
