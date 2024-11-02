'use client';

import React, { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Search from './Search';
import { handleLocationShare } from '../services/locationService';
import { handleAddressSubmit } from '../services/geocodeService';
import { trackVisit } from '../services/analytics';
import { Location } from '../types';
import Image from 'next/image';

const SearchContainer: React.FC = () => {
  const router = useRouter();

  useEffect(() => {
    trackVisit();
  }, []);

  return (
    
    <section
    // Since this is a background CSS - in - JS was a better option than Next.js IMG
      className="relative bg-[url(https://images.pexels.com/photos/5454020/pexels-photo-5454020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2)] bg-cover bg-center bg-no-repeat shadow-2xl max-h-400 mx-auto max-w-7xl px-5 py-16 md:px-10 md:py-20"
      >
      <><div
        className="absolute inset-0 md:bg-gradient-to-r md:from-white/75 md:to-transparent "
      ></div>
      {/* for small screens */}
      <div
      className="absolute inset-0 bg-white/55 sm:bg-transparent sm:from-white/75 sm:to-white/10 sm:bg-gradient-to-r"
      ></div>

      <div
          className="relative mx-auto max-w-screen-6xl px-4 py-32 sm:px-6 lg:flex lg:h-screen lg:items-center lg:px-8"
        >
            <div className="max-w-xl text-center sm:text-left ">
              
            <p className=" font-bold sm:text-2xl lg:text-4xl font-thirsty pb-4">
            ~ Anywhere, Anytime ~
            </p>

            <h1 className="font-extrabold text-5xl">
            Find Your New Favorite

        <p className="block py-2"> 
            <span className="text-rose-800">T</span>
            <span className="text-emerald-800">A</span>
            <span className="text-yellow-600">C</span>
            <span className="text-orange-700">O </span>
            
            <span className="text-rose-800">S</span>
            <span className="text-emerald-800">P</span>
            <span className="text-yellow-600">O</span>
            <span className="text-rose-800">T</span>
            <span></span>
            <Image
              src="/logo.svg"
              alt="Clipart Taco"
              width={50}
              height={50}
              className="mr-4 inline-block"
              priority
            />
         </p>
         
          </h1>

              <p className="mt-4 max-w-lg sm:text-xl/relaxed">
                Share or enter your location to get started
              </p>
              
              {/* Come back and edit this section to fit better both large and small screens- make buttons responsive  */}
              <div className="mt-8 flex flex-wrap gap-4 text-center align-left">
              <Search
              onLocationShare={(loc: Location) => handleLocationShare(loc, router)}
              onAddressSubmit={(address: string) =>
                handleAddressSubmit(address, router)
              }
            />
              </div>

            </div>
          </div></>
    </section>

  );
};

export default SearchContainer;
