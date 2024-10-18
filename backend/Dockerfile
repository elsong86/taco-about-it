FROM python:3.11-slim AS backend

# Set the working directory
WORKDIR /backend

# Set environment variables to prevent .pyc files and buffer stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install gcc, g++, and libc-dev
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libc-dev \
    && apt-get clean

# Copy only requirements.txt first to leverage Docker layer caching
COPY requirements.txt .

# Upgrade pip and install Python dependencies from requirements.txt
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the backend port
EXPOSE 8000

# Run the backend server using uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload", "--log-level", "debug"]
