// app/page.tsx

import React from 'react';
import MainHead from './components/LandingHeader';
import Footer from './components/Footer';
import InteractiveSection from './components/InteractiveSection';
import Image from 'next/image';

const HomePage: React.FC = () => {
  return (
    <div>
      <MainHead />
      <div
        className="flex min-h-screen flex-col items-center justify-center relative"
        style={{
          position: 'relative',
        }}
      >
        {/* Optimized Image as Background */}
        <Image
          src="/images/stock-photo-sumptuous-taco-feast-a-detailed-and-realistic-culinary-delight-on-a-dark-brown-table-2472438793.jpg"
          alt="Sumptuous Taco Feast"
          fill
          style={{ objectFit: 'cover' }}
          quality={75}
          priority
        />

        {/* Transparent Black Gradient Overlay */}
        <div
          className="absolute inset-0 bg-gradient-to-b from-black/50 to-black/20"
          style={{ opacity: 0.7 }}
        ></div>

        {/* Interactive Content */}
        <InteractiveSection />
      </div>
      <Footer />
    </div>
  );
};

export default HomePage;
