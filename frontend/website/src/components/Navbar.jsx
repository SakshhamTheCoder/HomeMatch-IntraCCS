import React from 'react';
import { Link } from 'react-router-dom';

const Navbar = () => {
    const links = [
        {
            name: 'Home',
            path: '/'
        },
        {
            name: 'Gallery',
            path: '/gallery'
        },
        {
            name: 'About Us',
            path: '/about'
        },
        {
            name: 'Advertise',
            path: '/advertise'
        },
        {
            name: 'FAQ',
            path: '/faq'
        },
    ];

    return (
        <nav className="sticky top-0 z-50 px-8 flex items-center justify-center w-full bg-background rounded-b-3xl h-16">
            <div className='flex items-center justify-start flex-1 font-bold'>
                <p className='p-4'>Home Maker</p>
                <p className='select-none'>|</p>
            </div>
            <div className='flex items-center justify-center flex-1'>
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

// const Navbar = () => {
//   return (
//     <nav className="bg-black top-0 z-50 px-8 p-4 h-16 w-full flex items-center justify-center rounded-b-3xl">
//       <div className="container mx-auto flex items-center justify-between">
//         {/* Logo */}
//         <div className="text-white text-2xl font-bold flex items-center">
//           <Link to="/" className="mr-4">Your Logo</Link>
//         </div>
        
//         {/* Navigation Links */}
//         <div className="flex space-x-4">
//           <Link to="/" className="text-gray-300 hover:text-white">Home</Link>
//           <Link to="/gallery" className="text-gray-300 hover:text-white">Gallery</Link>
//           <Link to="/about" className="text-gray-300 hover:text-white">About Us</Link>
//           <Link to="/faq" className="text-gray-300 hover:text-white">FAQ</Link>
//           <Link to="/advertise" className="text-gray-300 hover:text-white">Advertise</Link>
//         </div>
//       </div>
//     </nav>
//   );
// };



// const Navbar = () => {
//     const links = [
//         {
//             name:'Home',
//             path:'/'
//         },
//         {
//             name:'Gallery',
//             path:'/gallery'
//         },
//         {
//             name:'About Us',
//             path:'/about'
//         },
//         {
//             name:'Advertise',
//             path:'/advertise'
//         },
//         {
//             name:'FAQ',
//             path:'/faq'
//         },
//     ];
//     return (
//         <>
//         <nav className={'sticky top-0 z-50 px-8 flex items-center justify-center w-full bg-background rounded-b-3xl h-16'}>
//         <div className='flex items-center justify-start flex-1 font-bold'>
//                     <p className='p-4'>Home Maker</p>
//                     <p className='select-none'>|</p>
//         </div>
//         <div className='flex items-center justify-center flex-1'>
//                     {links.map((link, index) => {
//                         return (
//                             <Link key={index} to={link.path}>
//                                 <p className={`p-4 hover:text-secondary transition duration-150 ${href === link.path ? 'text-secondary font-bold' : ''}`}>
//                                     {link.name}
//                                 </p>
//                             </Link>
//                         );
//                     })}
//         </div>
//         <Outlet />
//         </nav>
//         </>
//     );
// };



export default Navbar;
