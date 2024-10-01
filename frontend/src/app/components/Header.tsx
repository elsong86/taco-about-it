import React from 'react';
import { Location } from '../types';
import Link from 'next/link';

interface HeaderProps {
  onLocationShare: (location: Location) => void;
  onAddressSubmit: (address: string) => void;
}

const Header: React.FC<HeaderProps> = ({
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
        },
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
    <header className="mb-4 flex flex-col items-center justify-between md:flex-row">
      <div className="flex items-center w-full md:w-auto">
        <button
          onClick={handleLocationShare}
          className="mb-2 rounded bg-blue-500 p-2 text-white md:mb-0 md:mr-2"
        >
          Share Location
        </button>
        <form onSubmit={handleAddressSubmit} className="flex items-center">
          <input
            name="address"
            type="text"
            placeholder="Enter address"
            required
            className="mr-2 rounded border bg-opacity-50 bg-white p-2"
          />
          <button type="submit" className="rounded bg-green-500 p-2 text-white">
            Search
          </button>
        </form>
      </div>
      <div className="flex justify-end w-full md:w-auto mt-2 md:mt-0">
        {/* <Link
          href="/signin"
          className="text-blue-500 hover:text-blue-700 font-bold mr-4"
        >
          Sign in
        </Link>
        <Link
          href="/signup"
          className="text-blue-500 hover:text-blue-700 font-bold"
        >
          Sign up
        </Link> */}
      </div>
    </header>
  );
};

export default Header;
