import React from "react";
import rip from '../../../public/footer.svg'

const Footer: React.FC = () => {
  return (
    <div className="relative bottom-0 left-0 w-full bg-gray-800 text-white p-4  pt-10 flex items-center flex-col justify-center">
      <div className="absolute inset-x-0 top-[-20px] w-full h-auto z-10  hidden md:block">
        <img src={rip.src} alt="Ripped Paper Effect" className="w-full" />
      </div>
      <div>
      <h1 className="text-lg"
      >
        Join the party!
        </h1>
      </div>

      <div>
        <span>M</span>
        <span>I</span>
        <span>T</span>
        <span> </span>
        <span>L</span>
        <span>I</span>
        <span>C</span>
        <span>E</span>
        <span>N</span>
        <span>C</span>
        <span>E</span>
      </div>
      <div>
        <p>Made with ♡</p>

      </div>

    </div>
  );
};

export default Footer;