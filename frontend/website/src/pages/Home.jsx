import React, { useEffect, useState } from 'react';
import Image1 from '../assets/home1.jpg';
import Image2 from '../assets/home2.jpg';
import Image3 from '../assets/home3.jpg';

const Home = () => {
  const images = [Image1, Image2, Image3];
  const heroData = [
    { text1: "Find your", text2: "home your way!" },
    { text1: "Find your", text2: "perfect home!" },
    { text1: "Find your", text2: "own dream space!" },
  ];
  const [heroCount, setHeroCount] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setHeroCount(count => (count === 2 ? 0 : count + 1));
    }, 3000);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="relative flex flex-col items-center overflow-hidden min-h-screen">
      {images.map((image, index) => (
        <img
          key={index}
          src={image}
          className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-1000 ${heroCount === index ? 'opacity-100' : 'opacity-0'}`}
          alt=""
        />
      ))}
      <div className="absolute bottom-0 left-20 transform -translate-y-1/2 text-black">
        <div className='bg-white bg-opacity-50 p-12 rounded-full font-times'>
        <p className="text-4xl font-semibold">{heroData[heroCount].text1}</p>
        <p className="text-4xl font-semibold">{heroData[heroCount].text2}</p>
        </div>
        <br/><br/><br/>
        <div className="absolute bottom-10 left-1/2 transform -translate-x-1/2 flex justify-center mt-120">
        <ul className="hero-dots flex items-center gap-2 list-none">
          {images.map((_, index) => (
            <li
              key={index}
              onClick={() => setHeroCount(index)}
              className={`hero-dot w-4 h-4 cursor-pointer rounded-full bg-white ${heroCount === index ? 'bg-yellow-300' : ''}`}>
            </li>
          ))}
        </ul>
      </div>
      </div>
      

    </div>
  );
};

export default Home;
