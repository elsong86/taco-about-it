'use client';

import React, { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Header from '../app/components/Header';
import { handleLocationShare } from './services/locationService';
import { handleAddressSubmit } from './services/geocodeService';
import { trackVisit } from './services/analytics';
import { Location } from './types';

import image from '../../public/images/copilottacos.jpeg'
import MainHead from '../../src/app/components/LandingHeader'
import Footer from './components/Footer';

const HomePage: React.FC = () => {
  const router = useRouter();

  useEffect(() => {
    trackVisit();
  }, []);

  return (

    <div>
      <MainHead />
      <div className="flex min-h-screen flex-col items-center justify-center relative "
        style={{
          backgroundImage: `url(${image.src})`,
          backgroundSize: "cover",
          backgroundPosition: "contain", 
          backgroundRepeat: "no-repeat", 
        }}
        >
          
    {/* Transparent black gradient div */}
    <div
        className="absolute inset-0"
        style={{
          background: "linear-gradient(to bottom, rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.2))",
          opacity: 0.7, // You can adjust this value for more or less transparency
        }}
      ></div>

        {/* Content */}
      <div className="relative z-5 flex flex-col items-center rounded-lg border border-gray-300 border-opacity-50 text-center shadow-2xl bg-gray-200 bg-opacity-50 my-10 pt-20 pb-10 px-10">

        <p className="font-thirsty font-bold text-3xl  ">
          ~ Anywhere, Anytime ~
              </p>

          <h1 className=" text-6xl font-brothers text-shadow-md py-4 text-neutral-950" >FIND YOUR NEW FAVORITE <br />TACO SPOT!</h1>
          <p className='font-avenir font-bold text-xl pb-5'>
                Enter your location to get started. 
              </p>
          <Header
            onLocationShare={(loc: Location) => handleLocationShare(loc, router)}
            onAddressSubmit={(address: string) =>
              handleAddressSubmit(address, router)
            }
          />
        </div>

      </div>
      <Footer />
    </div>
  );
};

export default HomePage;
