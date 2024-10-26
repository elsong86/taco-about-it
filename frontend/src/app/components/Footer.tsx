import React from "react";
import Link from "next/link";
import rip from '../../../public/footer.svg'
import github from '../../../public/github.svg'
import linkedin from '../../../public/linkedin.svg'
import taco from '../../../public/images/taco.png'
import pinata from '../../../public/images/pinata.png'


const Footer: React.FC = () => {
  return (
    <div className="relative bottom-0 left-0 w-full bg-gray-800 text-white p-4 pt-5 flex items-center flex-col justify-center">
      <div className="absolute inset-x-0 top-[-20px] w-full h-auto z-10 hidden md:block">
        <img src={rip.src} alt="Ripped Paper Effect" className="w-full" />
      </div>
      <div>
        <h1 className="text-lg py-2">Join the party!</h1>
      </div>

      <div>
        <p className="text-2xl py-5 ">Connect with us:</p>
      </div>

    {/* Flex container for icons and names */}
    <div className="flex flex-col space-y-4"> {/* Space between rows */}
        {/* Ellis's */}
        <div className="flex items-center space-x-4"
        
        > 
          <Link href="https://github.com/elsong86" target="_blank">
            <img
              src={github.src}
              alt="GitHub Icon"
              className="h-10 w-10  bg-rose-600 rounded-md p-1" 
            />
          </Link>
          <Link href="https://www.linkedin.com/in/ellissong/" target="_blank">
            <img
              src={linkedin.src}
              alt="LinkedIn Icon"
              className="h-10 w-10 bg-orange-700 rounded-md" 
            />
          </Link>
          <div className="text-5xl font-hustlers">
            <span className="text-rose-600">E</span>
            <span className="text-emerald-600">L</span>
            <span className="text-yellow-600">L</span>
            <span className="text-orange-700">I</span>
            <span className="text-rose-800">S</span>
          </div>
        </div>

        {/* Sofia's Icons and Name */}
        <div className="flex items-center space-x-4"> 
          <Link href="https://github.com/sarhiri" target="_blank">
            <img
              src={github.src}
              alt="GitHub Icon"
              className="h-10 w-10 bg-yellow-600 rounded-md p-1" 
            />
          </Link>
          <Link href="https://www.linkedin.com/in/sofia-sarhiri/" target="_blank">
            <img
              src={linkedin.src}
              alt="LinkedIn Icon"
              className="h-10 w-10  bg-emerald-600 rounded-md" 
            />
          </Link>
          <div className="text-5xl font-hustlers">
            <span className="text-emerald-600">S</span>
            <span className="text-rose-600">O</span>
            <span className="text-yellow-600">F</span>
            <span className="text-orange-700">I</span>
            <span className="text-rose-800">A</span>
          </div>
        </div>
      </div>


      <div className='py-6 font-thirsty'>
        <p>Made with ♡ in 2024</p>
      </div>

    </div>
  );
};

export default Footer;