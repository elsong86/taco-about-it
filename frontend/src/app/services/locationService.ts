import { useRouter } from 'next/navigation'; // Correct import for the app directory
import { Location } from '../types';

// Typing the router as ReturnType<typeof useRouter>
export function handleLocationShare(loc: Location, router: ReturnType<typeof useRouter>) {
  console.log('Location shared:', loc);
  router.push(`/search?latitude=${loc.latitude}&longitude=${loc.longitude}`);
}
