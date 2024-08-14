#!/bin/bash

# Navigate to the frontend directory and install Node.js dependencies
echo "Navigating to the frontend directory and installing Node.js dependencies..."
cd frontend
npm install

# Navigate back to the root directory
echo "Returning to the root directory..."
cd ..

# Navigate to the backend directory and install Python dependencies
echo "Navigating to the backend directory and installing Python dependencies..."
cd backend
pip install -r requirements.txt

echo "Setup complete!"