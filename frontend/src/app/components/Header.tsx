import React from 'react';
import { Location } from '../types'; // Adjust the import path as needed

interface HeaderProps {
  onLocationShare: (location: Location) => void;
  onAddressSubmit: (address: string) => void;
}

const Header: React.FC<HeaderProps> = ({ onLocationShare, onAddressSubmit }) => {
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
    <header className="flex flex-col md:flex-row items-center justify-between mb-4">
      <button onClick={handleLocationShare} className="p-2 bg-blue-500 text-white rounded mb-2 md:mb-0 md:mr-2">
        Share Location
      </button>
      <form onSubmit={handleAddressSubmit} className="flex items-center">
        <input
          name="address"
          type="text"
          placeholder="Enter address"
          required
          className="p-2 mr-2 border rounded"
        />
        <button type="submit" className="p-2 bg-green-500 text-white rounded">
          Search
        </button>
      </form>
    </header>
  );
};

export default Header;
