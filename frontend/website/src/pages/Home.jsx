import React, { useEffect, useState } from 'react';
import Image1 from '../assets/home1.jpg';
import Image2 from '../assets/home2.jpg';
import Image3 from '../assets/home3.jpg';

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
    <div className="relative flex flex-col items-center pt-16 min-h-screen overflow-hidden">
      {images.map((image, index) => (
        <img
          key={index}
          src={image}
          className={`absolute inset-0 w-full h-full object-cover transition-opacity duration-1000 ${heroCount === index ? 'opacity-100' : 'opacity-0'}`}
          alt=""
        />
      ))}
      <div className="absolute top-1/2 left-1/4 transform -translate-y-1/2 text-white text-center">
        <p className="text-4xl font-semibold">{heroData[heroCount].text1}</p>
        <p className="text-4xl font-semibold">{heroData[heroCount].text2}</p>
      </div>
      <div className="absolute bottom-10 left-1/2 transform -translate-x-1/2 flex justify-center mt-120">
        <ul className="hero-dots flex items-center gap-2 list-none">
          {images.map((_, index) => (
            <li 
              key={index} 
              onClick={() => setHeroCount(index)} 
              className={`hero-dot w-4 h-4 cursor-pointer rounded-full bg-white ${heroCount === index ? 'bg-orange-900' : ''}`}>
            </li>
          ))}
        </ul>
        <br/><br/><br/><br/><br/><br/>
      </div>
      <div className="absolute bottom-10 left-1/2 transform -translate-x-1/2 text-white text-center">
        <p className="text-xl mb-2">Indulge your passions</p>
        <div className="flex items-center justify-center gap-2">
          <div className="w-2 h-2 bg-white rounded-full"></div>
          <div className="w-2 h-2 bg-white rounded-full"></div>
          <div className="w-2 h-2 bg-white rounded-full"></div>
        </div>
      </div>
      <div className="absolute bottom-8 left-0 right-0 text-lg text-black bg-red-700 z-10">
        "Home Match Group is committed to ensuring digital accessibility for individuals using the platform. We are continuously working to improve the accessibility of our web and app experience for everyone, and we welcome feedback and accommodation requests. If you wish to report an issue or seek an accommodation, please let us know at xyz@gmail.com"
      </div>
      <div className='bottle'><p >Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quod eligendi pariatur ex deserunt quas libero delectus dolor obcaecati! Voluptate exercitationem hic, dolore quis id dicta explicabo ratione eligendi doloribus asperiores. Lorem ipsum dolor sit, amet consectetur adipisicing elit. Labore ratione esse eum nobis inventore voluptas enim suscipit excepturi soluta quas! Corrupti corporis necessitatibus voluptatibus delectus repudiandae? Suscipit repudiandae corporis temporibus!</p></div>
    </div>
  );
};

export default Home;
