# Taco Tracker App
![CI](https://github.com/elsong86/taco-tracker/actions/workflows/ci.yml/badge.svg)

A taco restaurant locator app that helps users find the best tacos in their area using geolocation and sentiment analysis.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Technologies](#technologies)
- [License](#license)
- [Contributors](#contributors)
- [Contact](#contact)

## Prerequisites

Before setting up the project, ensure you have the following installed:

- **Docker:** [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose:** [Install Docker Compose](https://docs.docker.com/compose/install/)

## Installation

To set up the project using Docker, follow these steps:

1. **Fork and clone the Repository:**
   - Fork the project repository to your GitHub account by clicking the "Fork" button at the top right of the repository page.
   - Clone the forked repository to your local machine:
     ```bash
     git clone https://github.com/your-username/taco-tracker.git
     cd taco-tracker
     ```

2. **Create the `.env` File:**
   - Create a .env file at the root of the project. 
   - This file should contain the following variables:
     ```plaintext
     GOOGLE_API_KEY=your_actual_google_api_key
     OUTSCRAPER_API_KEY=your_actual_outscraper_api_key
     ```
   - Replace `your_actual_google_api_key` and `your_actual_outscraper_api_key` with your actual API keys.

3. **Build and Start the Docker Containers:**
   - Use Docker Compose to build and start the containers for the frontend, backend, and Redis services:
     ```bash
     docker compose up --build
     ```
   - This will build the necessary Docker images and start the services.

4. **Access the Application:**
   - Once the containers are up and running, open your web browser and go to:
     ```plaintext
     http://localhost:3000
     ```
   - The application should be running, and you can start using it.

## GitHub Actions

This project uses GitHub Actions for Continuous Integration (CI). The CI pipeline is triggered on every push to the `main` branch and on pull requests. It ensures that the code is automatically tested and built using Docker Compose.

### What the CI Pipeline Does
- **Builds Docker Images:** Builds Docker images for the frontend, backend, and test environments.
- **Runs Tests:** Executes unit tests within Docker containers to ensure consistent behavior across environments.
- **Uses Docker Compose:** Orchestrates the services (frontend, backend, Redis) using Docker Compose to replicate a production-like environment.

## Usage

Once the Docker containers are running, the application is accessible at `http://localhost:3000`. You can use the app as follows:

1. **Using the App:**
   - On the homepage, you can either share your location or enter an address to find nearby taco restaurants.
   - Browse the list of restaurants and view sentiment analysis of user reviews to help you find the best tacos in your area.

2. **Stopping the Application:**
   - To stop the Docker containers, run:
     ```bash
     docker compose down
     ```
   - This will stop and remove the containers.

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

## Contributors
- [Ellis Song](https://github.com/elsong86)
- [Sofia Sarhiri](https://github.com/sarhiri)

