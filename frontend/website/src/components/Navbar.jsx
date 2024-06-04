import React from 'react';
import { Link } from 'react-router-dom';
import image5 from '../assets/logo_re.jpg';

const Navbar = () => {
    const links = [
        {
            name: 'Home',
            path: '/'
        },
        {
            name: 'About Us',
            path: '/about'
        },
        {
            name: 'FAQ',
            path: '/faq'
        },
        {
            name: 'Explore',
            path: '/explore'
        },
        {
            name: 'Why Home Match?',
            path: '/advertise'
        }
    ];

    return (
        <nav className="sticky top-0 z-50 px-8 flex items-center justify-center w-full bg-red-50 rounded-b-3xl h-16">
            <div className='flex items-center justify-start flex-1 font-bold bg-red-50'>
                <p className='p-4'>Hacktify</p>
                <p className='select-none'>|</p>
                <p className='p-4'>Home Match</p>
                <p className='select-none'>|</p>
                <img src={image5} alt="" className='pl-4 pb-1.25 '/>
            </div>
            <div className='flex items-center justify-center flex-1 '>
                {links.map((link, index) => (
                    <Link key={index} to={link.path}>
                        <p className="p-4 hover:text-secondary transition duration-150">
                            {link.name}
                        </p>
                    </Link>
                ))}
            </div>
        </nav>
    );
};

export default Navbar;
