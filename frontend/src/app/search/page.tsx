'use client';

import React, { useState, useEffect, Suspense } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import PlaceTile from '../components/PlaceTile';
import Search from '../components/Search';
import { Location, Place } from '../types';
import useSWR from 'swr';
import Footer from '../components/Footer';
import Link from 'next/link';
import Image from 'next/image';

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

  useEffect(() => {
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
      revalidateOnReconnect: false,
    }
  );

  const handleLocationShare = (loc: Location) => {
    setLocation(loc);
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
      router.push(
        `/search?latitude=${location.latitude}&longitude=${location.longitude}`,
      );
    } catch (error) {
      console.error('Error geocoding address:', error);
    }
  };

  return (
    <div>
      <div className="justify-center sm:justify-center md:justify-start lg:justify-start space-x-2 py-6 px-8">
        <Link
          href={{
            pathname: '/',
          }}
          className="flex items-center text-lg space-x-2 group"
        >
          <Image
            src="arrow-left-svgrepo-com.svg"
            alt="Clipart Onion"
            width={20}
            height={20}
            className="relative py-2"
            priority
          />
          <span className="group-hover:text-emerald-600 transition-colors">
            Home
          </span>
        </Link>
      </div>

      <main className="items-left flex min-h-screen flex-col p-4 px-10">
        <h1 className="mb-4 text-2xl font-bold">Search Results</h1>
        
        {/* Wrap the section that depends on asynchronous data with Suspense */}
        <Suspense fallback={<div>Loading places...</div>}>
          <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
            {error && <div>Error fetching places.</div>}
            {placesData &&
              placesData.places.map((place: Place) => (
                <PlaceTile key={place.id} place={place} />
              ))}
          </div>
        </Suspense>
      </main>
      <Footer />
    </div>
  );
};

export default SearchPage;
