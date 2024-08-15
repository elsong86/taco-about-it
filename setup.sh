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

# Create a .env file in the backend directory with placeholder values
echo "Creating .env file in the backend directory..."
cat <<EOT >> .env
# Environment variables for the backend
GOOGLE_API_KEY=your_google_api_key_here
OUTSCRAPER_API_KEY=your_outscraper_api_key_here
EOT

echo ".env file created with placeholder API keys. Please update it with your actual API keys."

echo "Setup complete!"
