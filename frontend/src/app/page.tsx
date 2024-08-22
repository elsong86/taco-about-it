'use client';

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
    <div className="flex min-h-screen flex-col items-center justify-center">
      <div className="flex flex-col items-center rounded-lg border border-gray-300 p-20 text-center shadow-2xl">
        <h1 className="mb-6 text-3xl font-bold">Welcome to Taco Finder</h1>
        <Header
          onLocationShare={(loc: Location) => handleLocationShare(loc, router)}
          onAddressSubmit={(address: string) =>
            handleAddressSubmit(address, router)
          }
        />

        <p>
          This is the landing page. Use the search functionality to find tacos!
        </p>
      </div>
    </div>
  );
};

export default HomePage;
