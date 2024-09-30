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
    <div className="flex min-h-screen flex-col items-center justify-center relative bg-white">
    {/* Triangle Background */}
    <div className="absolute inset-0">
      <div className="absolute top-0 left-0 w-0 h-0 border-t-[100vh] border-t-[#eece30] border-r-[100vw] border-r-transparent"></div>
    </div>

    {/* Content */}
    <div className="relative z-10 flex flex-col items-center rounded-lg border border-gray-300 p-20 text-center shadow-2xl bg-white">
      <h1 className="mb-6 text-6xl font-brothers">Welcome to Taco Finder</h1>
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
