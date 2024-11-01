'use client';

import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import Image from 'next/image';

const SignInPage: React.FC = () => {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isClient, setIsClient] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    // Indicate that the component has mounted on the client
    setIsClient(true);
  }, []);

  const handleSignin = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const response = await fetch('http://localhost:8000/signin', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
        credentials: 'include',  // This ensures cookies are sent with the request
      });

      if (response.status === 429) {
        throw new Error('Too many requests. Please try again later.');
      }

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.detail || 'Sign in failed');
      }

      // On success, dispatch the authChange event
      const authChangeEvent = new Event('authChange');
      window.dispatchEvent(authChangeEvent);

      // Redirect to home or dashboard
      window.location.href = '/'; // Use window.location.href for full page reload
    } catch (error: any) {
      console.error('Sign in failed:', error.message);
      setError(error.message);  // Display an error message to the user
    }
  };

  if (!isClient) {
    // Prevent rendering on the server to avoid mismatches
    return null;
  }

  return (

    <section className="">
    <div className="lg:grid lg:min-h-screen lg:grid-cols-12">

        {/* h-0 hides the image on mobile screens */}
      <aside className="relative block h-0 lg:order-first lg:col-span-5 lg:h-full xl:col-span-6">
      <Image
              src="/images/pexels-nubikini-1178991.jpg"
              alt="Neon Sign saying tacos"
              layout="fill" // Covers the container like the original <img>
              objectFit="cover" // Matches object-cover in CSS
              priority // Ensures image is loaded early
              quality={100} // Optional: set quality to max for a sharper image
              className="absolute inset-0 "
            />
      </aside>

      <main
        className="flex items-center justify-center px-8 py-6 sm:px-12 lg:col-span-7 lg:px-16 lg:py-8 xl:col-span-6"
      >
        <div className="max-w-xl lg:max-w-3xl">
        
        <Image
              src="/logo.svg"
              alt="Clipart Taco"
              width={100}
              height={100}
              className="ml-4 inline-block"
              priority
            />
              {/* Taco About It */}

          <h1 className="mt-6 text-2xl font-bold text-gray-900 sm:text-3xl md:text-4xl">
            Log In to 
            <span className="text-rose-800"> T</span>
            <span className="text-emerald-800">A</span>
            <span className="text-yellow-600">C</span>
            <span className="text-orange-700">O </span>
            <span> </span>
            <span className="text-rose-800">A</span>
            <span className="text-emerald-800">B</span>
            <span className="text-yellow-600">O</span>
            <span className="text-orange-700">U</span>
            <span className="text-rose-800">T</span>
            <span> </span>
            <span className="text-emerald-800">I</span>
            <span className="text-yellow-600">T</span>
            !
          </h1>
          
          <p className="mt-4 leading-relaxed text-gray-500 text-xl">
            
          </p>

          <form onSubmit={handleSignin} className="mt-8 grid grid-cols-6 gap-6">

            {/* email */}

          <div className="col-span-6">
            <label
              className="block text-sm font-medium text-gray-700"
              htmlFor="email"
            >
              Email
            </label>
            <input
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="email"
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          {/* password */}

          <div className="col-span-6">
            <label
              className="block text-sm font-medium text-gray-700"
              htmlFor="password"
            >
              Password
            </label>
            <input
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="password"
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>

          {error && (
            <p className="text-red-500 text-sm mb-4 whitespace-nowrap">{error}</p>
          )}



          <div className="col-span-6 sm:flex sm:items-center sm:gap-4">
          <button
              className= "inline-block shrink-0 rounded-md border border-blue-600 bg-blue-600 px-12 py-3 text-sm font-medium text-white transition hover:bg-transparent hover:text-blue-600 focus:outline-none focus:ring active:text-blue-500"
              type="submit"
            >
              Sign In
            </button>
          </div>
          
          </form>
          <p className="mt-4 pt-4 text-sm text-gray-500 sm:mt-0">
          Don't have an account?{' '}
          <Link
            href="/signup"
            className="text-gray-700 underline"
          >
            Sign Up
          </Link>
        </p>
        </div>
      </main>
    </div>
  </section>














    // <div className="flex min-h-screen flex-col items-center justify-center">
    //   <div className="flex flex-col items-center rounded-lg border border-gray-300 p-20 text-center shadow-2xl">
    //     <h1 className="mb-6 text-3xl font-bold">Log In</h1>
    //     <form onSubmit={handleSignin} className="w-full max-w-sm">
          // <div className="mb-4">


          //   <label
          //     className="block text-gray-700 text-sm font-bold mb-2"
          //     htmlFor="email"
          //   >
          //     Email
          //   </label>
          //   <input
          //     className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
          //     id="email"
          //     type="email"
          //     placeholder="Enter your email"
          //     value={email}
          //     onChange={(e) => setEmail(e.target.value)}
          //     required
          //   />
          // </div>


          // <div className="mb-6">
          //   <label
          //     className="block text-gray-700 text-sm font-bold mb-2"
          //     htmlFor="password"
          //   >
          //     Password
          //   </label>
          //   <input
          //     className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 mb-3 leading-tight focus:outline-none focus:shadow-outline"
          //     id="password"
          //     type="password"
          //     placeholder="Enter your password"
          //     value={password}
          //     onChange={(e) => setPassword(e.target.value)}
          //     required
          //   />
          // </div>
          // {error && (
          //   <p className="text-red-500 text-sm mb-4">{error}</p>
          // )}


    //       <div className="flex items-center justify-between">
    //         <button
    //           className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
    //           type="submit"
    //         >
    //           Sign In
    //         </button>
    //       </div>
    //     </form>
        
        // <p className="mt-6">
        //   Don't have an account?{' '}
        //   <Link
        //     href="/signup"
        //     className="text-blue-500 hover:text-blue-700 font-bold"
        //   >
        //     Sign Up
        //   </Link>
        // </p>
    //   </div>
    // </div>
  );
};

export default SignInPage;
