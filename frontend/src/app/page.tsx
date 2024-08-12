"use client";

import React, { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Header from '../app/components/Header';
import { handleLocationShare } from './services/locationService';
import { handleAddressSubmit } from './services/geocodeService';
import { trackVisit } from './services/analytics';
import { Location } from './types';

const HomePage: React.FC = () => {
  const router = useRouter();

  useEffect(() => {
    trackVisit(); 
  }, []);

  return (
    <div>
      <Header
        onLocationShare={(loc: Location) => handleLocationShare(loc, router)}
        onAddressSubmit={(address: string) => handleAddressSubmit(address, router)}
      />
      <h1 className="text-3xl font-bold mb-6">Welcome to Taco Finder</h1>
      <p>This is the landing page. Use the search functionality to find tacos!</p>
    </div>
  );
};

export default HomePage;
