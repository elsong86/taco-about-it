# Frontend service
FROM node:22.6.0 AS frontend

# Set the working directory
WORKDIR /frontend

# Copy the frontend package.json and package-lock.json files
COPY frontend/package*.json ./

# Install frontend dependencies
RUN npm install

# Copy the rest of the frontend files
COPY frontend/ .

# Expose the frontend port
EXPOSE 3000

# Backend service
FROM python:3.12-slim AS backend

# Set the working directory
WORKDIR /backend

# Set PYTHONPATH to include the /backend directory
ENV PYTHONPATH=/backend

# Copy the backend requirements.txt file
COPY backend/requirements.txt .

# Install backend dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the backend files
COPY backend/ .

# Expose the backend port
EXPOSE 8000

# Command to run the backend server
CMD ["python", "app/main.py"]

# Testing stage
FROM backend AS tests

# Install additional testing dependencies
RUN pip install httpx  # Remove 'unittest' as it's part of Python's standard library

# Set environment variables for testing, if needed
ENV REDIS_HOST=redis

# Command to run unit tests
CMD ["python", "-m", "unittest", "discover", "-s", "tests"]
