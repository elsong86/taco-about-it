"use client"; // Make this a client component

import { createContext, useContext, useState, useEffect } from 'react';

// Define the shape of the authentication context
interface AuthContextProps {
  isAuthenticated: boolean;
}

// Create the AuthContext
const AuthContext = createContext<AuthContextProps | undefined>(undefined);

// AuthProvider component
export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  useEffect(() => {
    // Client-side check for the access token in the cookies
    const token = document.cookie.includes('access_token');
    setIsAuthenticated(!!token);
  }, []);

  return (
    <AuthContext.Provider value={{ isAuthenticated }}>
      {children}
    </AuthContext.Provider>
  );
}

// Custom hook to use the AuthContext
export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}
