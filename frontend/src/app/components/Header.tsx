import React from 'react';
import { Location } from '../types';

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
          className="mr-2 rounded border p-2"
        />
        <button type="submit" className="rounded bg-green-500 p-2 text-white">
          Search
        </button>
      </form>
    </header>
  );
};

export default Header;
