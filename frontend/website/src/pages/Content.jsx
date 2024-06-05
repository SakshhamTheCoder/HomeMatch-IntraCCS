import React from 'react';
import image from '../assets/ref.jpeg';
import logo from '../assets/logo.jpeg'; // Import the logo image

const Content = () => {
  return (
    <div className="flex min-h-screen flex-col items-center pt-12 font-bold text-xl relative bg-gray-100">
      <h2 className="text-3xl font-extrabold text-gray-900 mb-6">WELCOME!</h2>
      <h3 className="text-4xl font-extrabold text-blue-600 mb-4">WE ARE HOME MATCH!</h3>
      <p className="text-lg text-yellow-700 text-center mb-6 max-w-3xl">
        Home Match is dedicated to providing you with the best platform to find your perfect home. Our innovative app simplifies the process of home searching, ensuring you have access to the best listings and the latest information. Join us on this journey and download our app to explore our creation!
      </p>
      <br/>
      <div className="flex w-full justify-around mb-12">
        <div className="flex flex-col items-center w-1/2 px-4">
          <p className="text-[17px] text-gray-600 text-center mb-6">
            You can download our app to explore our creation!
          </p>
          <img src={image} alt="App Preview" className="w-full h-auto pl-3"/>
        </div>
        <div className="flex flex-col items-center w-1/2 px-4">
          <p className="text-[17px] text-gray-600 text-center mb-6">
            This is our logo
          </p>
          <img src={logo} alt="Our Logo" className="w-1/2 h-auto"/>
        </div>
      </div>
      <hr className="w-full border-gray-300 mb-12"/>
      <div className="w-full flex flex-col items-center">
        <div className="flex flex-col items-center w-1/2 px-4 mb-6">
        <p className="text-[10px] text-center text-[#69908c] font-arial"> 
        HomeMatch Group is committed to ensuring digital accessibility for individuals. We are continuously working to improve the accessibility of our web and app experience for everyone, and we welcome feedback and accommodation requests. If you wish to report an issue or seek an accommodation, please inform us at homematch@gmail.com 
        </p>
        </div>
      </div>
    </div>
  );
};

export default Content;
