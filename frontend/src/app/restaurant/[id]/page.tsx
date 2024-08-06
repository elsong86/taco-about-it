"use client";

import { useSearchParams } from 'next/navigation';
import { useEffect, useState } from 'react';
import { Place } from '../../types';

const RestaurantPage: React.FC = () => {
  const searchParams = useSearchParams();
  const [place, setPlace] = useState<Place | null>(null);

  useEffect(() => {
    const id = searchParams.get('id');
    const displayName = searchParams.get('displayName');
    const formattedAddress = searchParams.get('formattedAddress');
    const rating = searchParams.get('rating');
    const userRatingCount = searchParams.get('userRatingCount');

    if (id && displayName && formattedAddress) {
      setPlace({
        id,
        displayName: { text: displayName, languageCode: 'en' }, // Assuming languageCode is 'en'
        formattedAddress,
        location: { latitude: 0, longitude: 0 }, // Dummy location, replace if available
        types: [], // Dummy types, replace if available
        rating: rating ? parseFloat(rating) : undefined,
        userRatingCount: userRatingCount ? parseInt(userRatingCount, 10) : undefined,
      });
    }
  }, [searchParams]);

  if (!place) {
    return <div>Loading...</div>; // Handle case where place is not available
  }

  return (
    <div className="p-4">
      <h1 className="text-3xl font-bold mb-4">{place.displayName.text}</h1>
      <p>{place.formattedAddress}</p>
      {place.rating && <p>Rating: {place.rating}</p>}
      {place.userRatingCount && <p>Reviews: {place.userRatingCount}</p>}
      {/* Add more static details as necessary */}
    </div>
  );
};

export default RestaurantPage;
