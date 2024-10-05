'use client';

import React, { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import PlaceTile from '../components/PlaceTile';
import Search from '../components/Search';
import { Location, Place } from '../types';
import useSWR from 'swr';

// Adjusted fetcher to accept a tuple (array) of arguments from useSWR
const usePlacesFetcher = async ([url, params]: [string, any]) => {
  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(params),
  });

  if (!response.ok) {
    throw new Error('Network response was not ok');
  }

  return response.json();
};

const SearchPage: React.FC = () => {
  const [location, setLocation] = useState<Location | null>(null);
  const searchParams = useSearchParams();
  const router = useRouter();

  console.log('Component rendered');

  useEffect(() => {
    console.log('useEffect triggered');
    const latitude = searchParams.get('latitude');
    const longitude = searchParams.get('longitude');

    if (latitude && longitude) {
      const loc: Location = {
        latitude: parseFloat(latitude),
        longitude: parseFloat(longitude),
      };
      setLocation(loc);
    }
  }, [searchParams]);

  const params = location
    ? {
        location: location,
        radius: 1000,
        max_results: 20,
        text_query: 'tacos',
      }
    : null;

    const { data: placesData, error } = useSWR(
      location ? ['http://localhost:8000/places', params] : null, 
      usePlacesFetcher, 
      {
        dedupingInterval: 86400000,  
        revalidateOnFocus: false,    
        revalidateOnReconnect: false 
      }
    );

  const handleLocationShare = (loc: Location) => {
    setLocation(loc);
    console.log('Location shared:', loc);
    router.push(`/search?latitude=${loc.latitude}&longitude=${loc.longitude}`);
  };

  const useAddressSubmit = async (address: string) => {
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
      const location: Location = {
        latitude: data.latitude,
        longitude: data.longitude,
      };
      setLocation(location);
      console.log('Address geocoded:', location);
      router.push(
        `/search?latitude=${location.latitude}&longitude=${location.longitude}`,
      );
    } catch (error) {
      console.error('Error geocoding address:', error);
    }
  };

  return (
    <main className="items-left flex min-h-screen flex-col p-4">
      <Search
        onLocationShare={handleLocationShare}
        onAddressSubmit={useAddressSubmit}
      />
      <h1 className="mb-4 text-2xl font-bold">Search Results</h1>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
        {error && <div>Error fetching places.</div>}
        {!placesData && <div>Loading places...</div>}
        {placesData &&
          placesData.places.map((place: Place) => (
            <PlaceTile key={place.id} place={place} />
          ))}
      </div>
    </main>
  );
};

export default SearchPage;
