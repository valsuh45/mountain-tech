# Use a lightweight Node.js image as the base
FROM node:20-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package files first (for caching dependencies)
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --frozen-lockfile

# Copy the rest of the project files
COPY . .

# Build the Next.js app
RUN npm run build

# Use a minimal Node.js image for production
FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy necessary files from the builder stage
COPY --from=builder /app /app

# Expose the port Next.js runs on
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
