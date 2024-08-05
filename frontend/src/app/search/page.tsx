"use client";

import React, { useState, useEffect } from 'react';
import PlaceTile from '../components/PlaceTile';

interface Location {
  latitude: number;
  longitude: number;
}

interface Place {
  id: string;
  formattedAddress: string;
  displayName: {
    text: string;
    languageCode: string;
  };
  location: Location;
  types: string[];
}

const SearchPage: React.FC = () => {
  const [places, setPlaces] = useState<Place[]>([]);

  // Define default parameters
  const defaultParams = {
    location: {
      latitude: 33.7910235,
      longitude: -118.2618912,
    },
    radius: 1000,
    max_results: 20,
    text_query: "tacos",
  };

  useEffect(() => {
    const fetchPlaces = async () => {
      try {
        const response = await fetch('http://localhost:8000/places', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(defaultParams),
        });

        if (!response.ok) {
          throw new Error('Network response was not ok');
        }

        const data = await response.json();
        setPlaces(data.places);
      } catch (error) {
        console.error('Error fetching places:', error);
      }
    };

    fetchPlaces();
  }, []);

  return (
    <main className="flex flex-col min-h-screen items-left p-4">
      <h1 className="text-2xl font-bold mb-4">Search Results</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {places.map((place) => (
          <PlaceTile key={place.id} place={place} />
        ))}
      </div>
    </main>
  );
};

export default SearchPage;
