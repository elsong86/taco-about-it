import React from "react";
import Link from "next/link";
import rip from '../../../public/rip.svg';
import sombrero from '../../../public/images/sombrero.png'

const MainHead: React.FC = () => {
  return (
    <header
      className="sticky top-0 left-0 right-0 shadow-md h-35 z-10 py-4 flex items-center text-center"
      style={{ backgroundColor: '#E8E4D9' }}
    >
         {/* Sombrero Image */}
      <div className="flex-shrink-0 ml-6">
        <img src={sombrero.src} alt="Sombrero logo" className="h-30 w-20" />
      </div>

      {/* Title */}
      <div className="absolute left-1/2 transform -translate-x-1/2 text-center text-8xl text-bold  font-hustlers "
      style={{ textShadow: "2px 2px 0px black" }}
      >
        {/* Taco About it */}
        <span className="text-rose-800">T</span>
        <span className="text-emerald-800">A</span>
        <span className="text-yellow-600">C</span>
        <span className="text-orange-700">O</span>
        <span> </span>
        <span className="text-rose-800">A</span>
        <span className="text-emerald-800">B</span>
        <span className="text-yellow-600">O</span>
        <span className="text-orange-700">U</span>
        <span className="text-rose-800">T</span>
        <span> </span>
        <span className="text-emerald-800">I</span>
        <span className="text-yellow-600">T</span>
      </div>

      {/* Buttons Section */}
      <div className="flex space-x-4 ml-auto p-4">
        <Link
          href="/signin"
          className="inline-block px-4 py-2 text-amber-50 bg-rose-700 hover:bg-red-800 hover:shadow-lg font-bold font-thirsty text-lg rounded shadow"
        >
          Sign In
        </Link>
        <Link
          href="/signup"
          className="inline-block px-4 py-2 text-amber-50 bg-sky-700 hover:bg-red-800 hover:shadow-lg font-bold font-thirsty text-lg rounded shadow"
        >
          Sign Up
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
