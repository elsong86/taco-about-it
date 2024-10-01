import React from "react";
import Link from "next/link";
import rip from '../../../public/footer.svg'
import github from '../../../public/github.svg'
import linkedin from '../../../public/linkedin.svg'


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
        <p className="text-2xl py-5">Connect with us:</p>
      </div>

    {/* Flex container for icons and names */}
    <div className="flex flex-col space-y-4"> {/* Space between rows */}
        {/* Ellis's */}
        <div className="flex items-center space-x-4"> {/* Space between icons and name */}
          <Link href="https://github.com/your-username" target="_blank">
            <img
              src={github.src}
              alt="GitHub Icon"
              className="h-10 w-10 border bg-white rounded-md" // Added rounded-full for circular icon
            />
          </Link>
          <Link href="https://linkedin.com/in/your-linkedin-profile" target="_blank">
            <img
              src={linkedin.src}
              alt="LinkedIn Icon"
              className="h-10 w-10 border bg-white rounded-md" // Added rounded-full for circular icon
            />
          </Link>
          <span className="text-5xl font-hustlers">ELLIS</span>
        </div>

        {/* Sofia's Icons and Name */}
        <div className="flex items-center space-x-4"> {/* Space between icons and name */}
          <Link href="https://github.com/sofia-username" target="_blank">
            <img
              src={github.src}
              alt="GitHub Icon"
              className="h-10 w-10 border bg-white rounded-md" // Added rounded-full for circular icon
            />
          </Link>
          <Link href="https://linkedin.com/in/sofia-linkedin-profile" target="_blank">
            <img
              src={linkedin.src}
              alt="LinkedIn Icon"
              className="h-10 w-10 border bg-white rounded-md" // Added rounded-full for circular icon
            />
          </Link>
          <span className="text-5xl font-hustlers">Sofia</span>
        </div>
      </div>


      <div className='py-6'>
        <p>Made with ♡ in 2024</p>
      </div>

    </div>
  );
};

export default Footer;