import React from 'react';
import Header from './components/Header';
import Footer from './components/Footer';
import SearchContainer from './components/SearchContainer';
import Image from 'next/image';
import { cookies } from 'next/headers';

const HomePage: React.FC = () => {
  // Fetch the access_token from cookies on the server side
  const cookieStore = cookies();
  const token = cookieStore.get('access_token');
  
  // Determine if the user is authenticated (server-side)
  const initialIsAuthenticated = !!token;

  console.log('HomePage isAuthenticated:', initialIsAuthenticated);

  return (
    <div>
      {/* Pass the initial authentication state to Header */}
      <Header initialIsAuthenticated={initialIsAuthenticated} />
      <div
        className="flex min-h-screen flex-col items-center justify-center relative"
        style={{
          position: 'relative',
        }}
      >
        <Image
          src="/images/stock-photo-sumptuous-taco-feast-a-detailed-and-realistic-culinary-delight-on-a-dark-brown-table-2472438803.jpg"
          alt="Sumptuous Taco Feast"
          fill
          style={{ objectFit: 'cover' }}
          quality={75}
          priority
        />
        <div
          className="absolute inset-0 bg-gradient-to-b from-black/50 to-black/20"
          style={{ opacity: 0.7 }}
        ></div>
        <SearchContainer />
      </div>
      <Footer />
    </div>
  );
};

export default HomePage;
