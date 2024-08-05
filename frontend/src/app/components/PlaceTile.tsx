"use client";

import React from 'react';

interface Place {
  id: string;
  formattedAddress: string;
  displayName: {
    text: string;
    languageCode: string;
  };
}

interface PlaceTileProps {
  place: Place;
}

const PlaceTile: React.FC<PlaceTileProps> = ({ place }) => {
  return (
    <div className="border p-4 m-2 rounded shadow-lg">
      <h2 className="text-xl font-bold">{place.displayName.text}</h2>
      <p>{place.formattedAddress}</p>
    </div>
  );
};

export default PlaceTile;
