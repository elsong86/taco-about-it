"use client";

import React, { useEffect, useState } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import PlaceTile from '../components/PlaceTile';
import Header from '../components/Header';
import { Location, Place } from '../types';

const SearchPage: React.FC = () => {
  const [places, setPlaces] = useState<Place[]>([]);
  const [location, setLocation] = useState<Location | null>(null);
  const searchParams = useSearchParams();
  const router = useRouter();

  console.log('Component rendered');


  useEffect(() => {
    console.log('useEffect triggered');
    const latitude = searchParams.get('latitude');
    const longitude = searchParams.get('longitude');

    if (latitude && longitude) {
      const loc: Location = { latitude: parseFloat(latitude), longitude: parseFloat(longitude) };
      setLocation(loc);
      fetchPlaces(loc);
    }
  }, [searchParams]);

  const fetchPlaces = async (loc: Location) => {
    console.log('Fetching places');
    if (!loc) return;
    const params = {
      location: loc,
      radius: 1000,
      max_results: 20,
      text_query: "tacos",
    };

    try {
      const response = await fetch('http://localhost:8000/places', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(params),
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

  const handleLocationShare = (loc: Location) => {
    setLocation(loc);
    console.log('Location shared:', loc);
    router.push(`/search?latitude=${loc.latitude}&longitude=${loc.longitude}`);
  };

  const handleAddressSubmit = async (address: string) => {
    try {
      const response = await fetch('http://localhost:8000/geocode', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ address }),
      });

      if (!response.ok) {
        throw new Error('Network response was not ok');
      }

      const data = await response.json();
      const location: Location = { latitude: data.latitude, longitude: data.longitude };
      setLocation(location);
      console.log('Address geocoded:', location);
      router.push(`/search?latitude=${location.latitude}&longitude=${location.longitude}`);
    } catch (error) {
      console.error('Error geocoding address:', error);
    }
  };

  return (
    <main className="flex flex-col min-h-screen items-left p-4">
      <Header onLocationShare={handleLocationShare} onAddressSubmit={handleAddressSubmit} />
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
