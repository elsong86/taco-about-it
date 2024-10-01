import React from "react";
import Link from "next/link";
import rip from '../../../public/rip.svg';

const MainHead: React.FC = () => {
  return (
    <header
      className="sticky top-0 left-0 right-0 shadow-md h-35 z-10 py-4 flex items-center"
      style={{ backgroundColor: '#f4f2e7' }}
    >


      {/* Centered Text */}
      <div className="absolute left-1/2 transform -translate-x-1/2 text-8xl text-shadow-md font-hustlers ">
        Taco About it
      </div>

      {/* Links Section */}
      <div className="flex space-x-4 ml-auto p-4">
        <Link
          href="/signin"
          className="inline-block px-4 py-2 text-white bg-yellow-500 hover:bg-red-800 font-bold font-avenir rounded"
        >
          Sign in
        </Link>
        <Link
          href="/signup"
          className="inline-block px-4 py-2 text-white bg-green-700 hover:bg-red-800 hover:text-white font-bold font-avenir rounded"
        >
          Sign up
        </Link>
      </div>

      {/* Ripped Paper SVG at the bottom */}
      <div className="absolute inset-x-0 bottom-[-20px] w-full h-auto z-10 rotate-180 hidden md:block">
        <img src={rip.src} alt="Ripped Paper Effect" className="w-full" />
      </div>
    </header>
  );
};

export default MainHead;
