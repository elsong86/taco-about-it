"use client";

import React, { useState } from 'react';
import { useRouter } from 'next/navigation';
import Header from '../app/components/Header';
import { Location } from '../../types';

const HomePage: React.FC = () => {
  const [location, setLocation] = useState<Location | null>(null);
  const router = useRouter();

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
    <div>
      <Header onLocationShare={handleLocationShare} onAddressSubmit={handleAddressSubmit} />
      <h1 className="text-3xl font-bold mb-6">Welcome to Taco Finder</h1>
      <p>This is the landing page. Use the search functionality to find tacos!</p>
    </div>
  );
};

export default HomePage;
