import Cookies from 'js-cookie';

function trackVisit() {
    // Retrieve the 'visits' cookie, which might be a string or undefined
    let visits = Cookies.get('visits');

    // Convert it to a number, with a default of 0 if undefined
    let visitCount = parseInt(visits || '0', 10);

    // Increment the visit count
    visitCount++;

    // Store the updated visit count back in the cookie
    Cookies.set('visits', visitCount.toString(), { expires: 365 });
}

trackVisit();
