// app/layout.tsx
import React from 'react';
import { Inter } from 'next/font/google';
import './globals.css';
import { AuthProvider } from './context/AuthContext'; // Import AuthProvider

const inter = Inter({ subsets: ['latin'] });

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        {/* Wrap the app with AuthProvider */}
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}
