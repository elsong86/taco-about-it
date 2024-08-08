"use client";

import { useSearchParams } from 'next/navigation';
import { useEffect, useState } from 'react';
import { Place } from '../../types';

const RestaurantPage: React.FC = () => {
  const searchParams = useSearchParams();
  const [place, setPlace] = useState<Place | null>(null);
  const [reviews, setReviews] = useState<any[]>([]); // Initialize as an empty array
  const [loading, setLoading] = useState<boolean>(true);

  useEffect(() => {
    const id = searchParams.get('id');
    const displayName = searchParams.get('displayName');
    const formattedAddress = searchParams.get('formattedAddress');
    const rating = searchParams.get('rating');
    const userRatingCount = searchParams.get('userRatingCount');

    if (id && displayName && formattedAddress) {
      setPlace({
        id,
        displayName: { text: displayName }, // Only text, since languageCode is not needed
        formattedAddress,
        location: { latitude: 0, longitude: 0 }, // Dummy location, replace if available
        types: [], // Dummy types, replace if available
        rating: rating ? parseFloat(rating) : undefined,
        userRatingCount: userRatingCount ? parseInt(userRatingCount, 10) : undefined,
      });

      fetchReviews(id);
    }
  }, [searchParams]);

  const fetchReviews = async (placeId: string) => {
    setLoading(true);
    try {
      const response = await fetch(`http://localhost:8000/reviews?place_id=${placeId}`);
      if (!response.ok) {
        throw new Error(`Error: ${response.statusText}`);
      }
      const data = await response.json();
      console.log('Fetched reviews data:', data); // Log the fetched data
      if (data.reviews && Array.isArray(data.reviews)) {
        console.log('Setting reviews state:', data.reviews); // Log the reviews being set
        setReviews(data.reviews);
      } else {
        console.log('No reviews found in the response'); // Log if no reviews are found
        setReviews([]);
      }
    } catch (error) {
      console.error('Failed to fetch reviews:', error);
    } finally {
      setLoading(false);
    }
  };

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
      
      <h2 className="text-2xl font-bold mt-4">Reviews</h2>
      {loading ? (
        <div>Loading reviews...</div>
      ) : (
        reviews.length > 0 ? ( // Check if reviews is an array with length
          <ul>
            {reviews.map((review, index) => (
              <li key={index} className="mb-2">
                <p>-{review.review_text}</p>
              </li>
            ))}
          </ul>
        ) : (
          <div>No reviews available.</div>
        )
      )}
    </div>
  );
};

export default RestaurantPage;
