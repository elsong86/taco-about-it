# Taco Tracker App

A taco restaurant locator app that helps users find the best tacos in their area using geolocation and sentiment analysis.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Technologies](#technologies)
- [License](#license)
- [Contact](#contact)

## Installation

To automate the installation of dependencies for both the frontend and backend, you can use the provided `setup.sh` script. This script will:

1. Navigate to the `frontend` directory and run `npm install`.
2. Navigate back to the root directory.
3. Navigate to the `backend` directory and install the Python dependencies listed in `requirements.txt`.

### Steps to Run the Setup Script

1. **Ensure the Script is Executable:**
   - Before running the script, make sure it is executable by running the following command in the terminal:
     ```bash
     chmod +x setup.sh
     ```

2. **Run the Script:**
   - Execute the script from the root of your project directory by running:
     ```bash
     ./setup.sh
     ```
3. **Update the `.env` File:**
   - After the setup script runs, navigate to the `backend` directory and open the `.env` file.
   - Replace the placeholder values `your_google_api_key_here` and `your_outscraper_api_key_here` with your actual `GOOGLE_API_KEY` and `OUTSCRAPER_API_KEY`.
   - Example:
     ```plaintext
     GOOGLE_API_KEY=your_actual_google_api_key
     OUTSCRAPER_API_KEY=your_actual_outscraper_api_key
     ```

4. **Environment Variables:**
   - These keys are necessary for the application to function correctly. Ensure the `.env` file is updated before running the backend.

This script will handle the setup process for you, but you must manually update the `.env` file with your actual API keys to ensure the application works correctly.

## Usage

Once the setup is complete, you can start both the frontend and backend of the application concurrently by running:

1. **Start the Application:**
   - Navigate to the `frontend` directory and run:
     ```bash
     npm run dev
     ```
   - This command will utilize `concurrently` to run both the frontend and backend servers at the same time.
   - Open your web browser and go to `http://localhost:3000` to view the app.

2. **Using the App:**
   - On the homepage, share your location or enter an address to find nearby taco restaurants.
   - Browse the list of restaurants, and view sentiment analysis of user reviews to find the best tacos in your area.

## Features

- **Geolocation-Based Search:** Automatically find taco restaurants near your current location.
- **Address-Based Search:** Enter any address to search for nearby taco restaurants.
- **Sentiment Analysis:** Analyze reviews from Google Places to determine the most popular taco spots.
- **Responsive Design:** Optimized for both desktop and mobile devices.

## Technologies

- **Frontend:**
  - React
  - TypeScript
  - Next.js
- **Backend:**
  - Python
  - FastAPI 
  - Redis
- **Sentiment Analysis:**
  - TextBlob
- **APIs:**
  - Google Places API
  - Outscraper API

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

If you have any questions, feel free to reach out:

- **GitHub:** [elsong86](https://github.com/elsong86)
