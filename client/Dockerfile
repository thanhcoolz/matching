FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Ensure dependencies are installed before running the dev server
ENTRYPOINT ["sh", "-c", "npm install && npm run dev -- --host 0.0.0.0"]
