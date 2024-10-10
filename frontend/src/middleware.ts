import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
  // Extract the access token from the cookies
  const accessToken = request.cookies.get('access_token')?.value;

  console.log('Access Token:', accessToken);  // Log the token to see its presence

  if (!accessToken) {
    // If no token, redirect to the sign-in page
    console.log('No access token, redirecting to sign-in...');
    return NextResponse.redirect(new URL('/signin', request.url));
  }

  // Proceed with the request if the user is authenticated
  return NextResponse.next();
}

export const config = {
  matcher: ['/profile'],  // Protect the /profile route
};
