'use client';

import React, { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Header from '../app/components/Header';
import { handleLocationShare } from './services/locationService';
import { handleAddressSubmit } from './services/geocodeService';
import { trackVisit } from './services/analytics';
import { Location } from './types';

// import ripSvg from '../../public/rip.svg'
import backgroundImage from '../../public/images/tacos5.jpg'
import image from '../../public/images/copilottacos.jpeg'
import MainHead from '../../src/app/components/LandingHeader'

const HomePage: React.FC = () => {
  const router = useRouter();

  useEffect(() => {
    trackVisit();
  }, []);

  return (

    <div>
      <MainHead />
    <div className="flex min-h-screen flex-col items-center justify-center relative"
    style={{
      backgroundImage: `url(${image.src})`,
      backgroundSize: "cover",
      backgroundPosition: "contain", 
      backgroundRepeat: "no-repeat", 
    }}
    >
      

    {/* Triangle Background */}
    {/* <div className="absolute inset-0">
      <div className="absolute top-0 left-0 w-0 h-0 border-t-[100vh] border-t-[#eece30] border-r-[100vw] border-r-transparent"></div>

    </div> */}
      

    {/* Content */}
    <div className="relative z-10 flex flex-col items-center rounded-lg border border-gray-300 p-10 text-center shadow-2xl bg-transparent mt-10">
    <p className="font-thirsty text-3xl pb-0 ">
       ~ Anywhere, Anytime ~
          </p>
      <h1 className=" text-6xl font-brothers textShadow-lg" >FIND YOUR NEW FAVORITE <br />TACO SPOT</h1>
      <p className='font-semibold '>
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
  </div>
  );
};

export default HomePage;
