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

# Update system packages and install necessary dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential && apt-get clean

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /backend

# Copy the backend requirements.txt file
COPY backend/requirements.txt .

# Upgrade pip and install dependencies globally
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the backend files
COPY backend/ .

# Expose the backend port
EXPOSE 8000

# Command to run the backend server using uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

