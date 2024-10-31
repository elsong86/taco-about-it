// app/components/HomePageClient.tsx
"use client"; // Mark this as a Client Component

import React, { useState, useEffect } from 'react';
import Header from './Header';
import Footer from './Footer';
import SearchContainer from './SearchContainer';
import Image from 'next/image';
import NewHead from './NewHeader'

interface HomePageClientProps {
  initialIsAuthenticated: boolean;
}

const HomePageClient: React.FC<HomePageClientProps> = ({ initialIsAuthenticated }) => {
  // Client-side state to manage authentication after page load
  const [isAuthenticated, setIsAuthenticated] = useState(initialIsAuthenticated);

  // Client-side check to handle authentication state updates (like logging in/out)
  useEffect(() => {
    const checkAuthStatus = () => {
      // Since we can't access HTTP-only cookies, we'll rely on events or API calls
      // For simplicity, we'll assume an event is dispatched on auth change
      setIsAuthenticated(document.cookie.includes('access_token'));
    };

    // Listen for login/logout events and check authentication status
    window.addEventListener('authChange', checkAuthStatus);

    return () => {
      window.removeEventListener('authChange', checkAuthStatus);
    };
  }, []);

  console.log('HomePageClient isAuthenticated:', isAuthenticated);

  return (
    <div>
      {/* Pass the updated authentication state to Header */}
      {/* <Header initialIsAuthenticated={isAuthenticated} /> */}
      {/* Rest of your page content */}
      <NewHead initialIsAuthenticated={isAuthenticated}/>
      <div
        className="flex min-h-screen flex-col items-center justify-center relative"
        style={{ position: 'relative' }}
      >
        {/* <Image
          src="/images/stock-photo-sumptuous-taco-feast-a-detailed-and-realistic-culinary-delight-on-a-dark-brown-table-2472438803.jpg"
          alt="Sumptuous Taco Feast"
          fill
          style={{ objectFit: 'cover' }}
          quality={75}
          priority
        /> */}
        {/* <div
          className="absolute inset-0 bg-gradient-to-b from-black/50 to-black/20"
          style={{ opacity: 0.7 }}
        ></div> */}
        <SearchContainer />
      </div>
      <Footer />
    </div>
  );
};

export default HomePageClient;
