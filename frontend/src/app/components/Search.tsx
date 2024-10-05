'use client';

import React from 'react';
import { Location } from '../types';

interface HeaderProps {
  onLocationShare: (location: Location) => void;
  onAddressSubmit: (address: string) => void;
}

const Search: React.FC<HeaderProps> = ({
  onLocationShare,
  onAddressSubmit,
}) => {
  const handleLocationShare = () => {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const { latitude, longitude } = position.coords;
          onLocationShare({ latitude, longitude });
        },
        (error) => {
          console.error('Error getting location:', error);
        }
      );
    } else {
      console.error('Geolocation is not supported by this browser.');
    }
  };

  const handleAddressSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    const form = e.target as HTMLFormElement;
    const formData = new FormData(form);
    const address = formData.get('address') as string;
    onAddressSubmit(address);
  };

  return (
    <header className="mb-4 flex flex-col items-center justify-center md:flex-row w-full">
      {/* Container for Share Location Button and Search Form */}
      <div className="flex items-center space-x-4">
        {/* Share Location Button */}
        <button
          onClick={handleLocationShare}
          aria-label="Share your current location"
          className="rounded bg-sky-700 p-2 text-white font-bold text-lg hover:bg-white hover:bg-opacity-50 hover:text-sky-700 hover:shadow-lg transition"
        >
          Share Location
        </button>

        {/* Search Form */}
        <form onSubmit={handleAddressSubmit} className="flex items-center">
          <input
            name="address"
            type="text"
            placeholder="Enter address"
            aria-label="Address"
            required
            className="mr-2 rounded border border-gray-300 bg-opacity-50 bg-white text-neutral-900 p-2 focus:outline-none focus:ring-2 focus:ring-sky-500 transition w-48"
          />
          <button
            type="submit"
            className="rounded bg-yellow-600 p-2 text-white font-bold text-lg hover:text-black hover:bg-white hover:bg-opacity-50 hover:shadow-lg transition"
          >
            Search
          </button>
        </form>
      </div>
    </header>
  );
};

export default Search;
