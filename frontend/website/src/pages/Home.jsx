import React, { useEffect, useState } from 'react';
import Image1 from '../assets/home1.jpeg';
import Image2 from '../assets/home2.jpg';
import Image3 from '../assets/home3.jpeg';

const Home = () => {
  const images = [Image1, Image2, Image3];
  const heroData = [
    { text1: "Dive into", text2: "what you love" },
    { text1: "Indulge", text2: "your passions" },
    { text1: "Give in to", text2: "your passion" },
  ];
  const [heroCount, setHeroCount] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setHeroCount(count => (count === 2 ? 0 : count + 1));
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="flex flex-col items-center pt-16 relative min-h-screen">
      <div className="fixed inset-0">
        <img src={images[heroCount]} className="w-full h-full object-cover fadeIn" alt="" />
      </div>

      <div className="absolute top-1/2 left-1/4 transform -translate-y-1/2 text-white text-center">
        <p className="text-4xl">{heroData[heroCount].text1}</p>
        <p className="text-4xl">{heroData[heroCount].text2}</p>
      </div>

      <div className="absolute bottom-10 left-1/2 transform -translate-x-1/2 flex justify-center mt-120">
        <ul className="hero-dots flex items-center gap-2 list-none">
          {images.map((_, index) => (
            <li 
              key={index} 
              onClick={() => setHeroCount(index)} 
              className={`hero-dot w-4 h-4 cursor-pointer rounded-full bg-white ${heroCount === index ? 'bg-orange-500' : ''}`}>
            </li>
          ))}
        </ul>
      </div>

      <div className="relative mt-screen pt-8 px-4 bg-gray-900 text-white text-center">
        <p className="text-lg">
          "Home Match Group is committed to ensuring digital accessibility for individuals using the platform. We are continuously working to improve the accessibility of our web and app experience for everyone, and we welcome feedback and accommodation requests. If you wish to report an issue or seek an accommodation, please let us know at xyz@gmail.com"
        </p>
      </div>

      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
          }
          to {
            opacity: 1;
          }
        }
        .fadeIn {
          animation: fadeIn 1s ease-in-out;
        }
      `}</style>
    </div>
  );
};

export default Home;
