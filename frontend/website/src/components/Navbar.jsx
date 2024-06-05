import React from 'react';
import { Link } from 'react-router-dom';
import image5 from '../assets/logo_re.jpg';
import { useLocation } from 'react-router-dom';

const Navbar = () => {
    const location = useLocation();
    const links = [
        {
            name: 'Home',
            path: '/',
            number: 1
        },
        {
            name: 'Who are we?',
            path: '/content',
            number: 2
        },
        {
            name: 'Why Home Match?',
            path: '/advertise',
            number: 3
        },
        {
            name: 'FAQ',
            path: '/faq',
            number: 4
        },
        {
            name: 'Explore',
            path: '/explore',
            number: 5
        },
        {
            name: 'About Us',
            path: '/about',
            number: 6
        },
    ];

    return (
        <nav className="sticky top-0 z-50 px-8 flex items-center justify-center w-full bg-red-50 rounded-b-3xl h-16 ">
            <div className='flex items-center justify-start flex-1 font-bold bg-red-50'>
                <Link to="/">
                    <p className='p-4'>Hacktify</p>
                </Link>
                <p className='select-none'>|</p>
                <Link to="/">
                    <p className='p-4'>Home Match</p>
                </Link>
                <p className='select-none'>|</p>
                    <img src={image5} alt="" className='pl-4 pb-1.25 '/>
            </div>
            <div className='flex items-center justify-center flex-1 '>
                {links.map((link, index) => (
                    <Link key={index} to={link.path}>
                        <p className={`p-4 hover:text-secondary transition duration-300 ${location.pathname === link.path ? 'font-semibold border rounded-full py-2 shadow-xl px-6 bg-[rgb(249,243,243)] text-gray-700 animate-scale' : ''}`}>
                            {link.name}
                        </p>
                    </Link>
                ))}
            </div>
            <style jsx>{`
                @keyframes scale {
                  0% {
                    transform: scale(0.95);
                  }
                  100% {
                    transform: scale(1);
                  }
                }

                .animate-scale {
                  animation: scale 0.3s ease-out;
                }
            `}</style>
        </nav>
    );
};

export default Navbar;
