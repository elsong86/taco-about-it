import React from "react";
import Link from "next/link";

const MainHead: React.FC = () => {
  return (
    <header className="sticky top-0 bg-white shadow-md h-70 z-10">
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
    </header>
  );
};

export default MainHead;
