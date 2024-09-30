import React from "react";
import Link from "next/link";
import rip from '../../../public/rip.svg'

const MainHead: React.FC = () => {
  return (
    <header className="fixed top-0 left-0 right-0 bg-white shadow-md h-30 z-10"
    
    >
      <div className="flex justify-between items-center p-4">
        <div className="flex-1 text-center text-7xl font-bold font-hustlers">
          Taco About it
        </div>
        <div className="flex space-x-4">
        <Link
          href="/signin"
          className="inline-block px-4 py-2 text-white bg-blue-500 hover:bg-blue-700 font-bold rounded"
        >
          Sign in
        </Link>
        <Link
          href="/signup"
          className="inline-block px-4 py-2 text-blue-500 bg-white border border-blue-500 hover:bg-blue-500 hover:text-white font-bold rounded"
        >
          Sign up
        </Link>
        </div>
      </div>
      {/* Ripped Paper SVG at the bottom */}
      <div className="absolute inset-x-0 w-full z-10 rotate-180">
        <img src={rip.src} alt="Ripped Paper Effect" className="w-full" />
      </div>
    </header>
  );
};

export default MainHead;
