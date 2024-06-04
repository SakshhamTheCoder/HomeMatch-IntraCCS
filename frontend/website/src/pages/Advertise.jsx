import React from 'react';
import news1 from '../assets/news1.jpeg';
import news2 from '../assets/news2.jpeg';
import news3 from '../assets/news3.jpeg';
import news4 from '../assets/news4.jpeg';

const Advertise = () => {
  return (
    <div className="flex min-h-screen flex-col items-center pt-10"> {/* Adjusted padding top */}
      <h1 className="text-3xl font-semibold text-[rgb(2,78,146)] mb-4">WHY DID WE FELT THE NEED TO CONSIDER THIS TOPIC?</h1>
      <h2>To understand the importance of this issue, let us consider the following recent news articles! </h2>
      <br/>
      {/* <div className="my-8 border-t-2 border-gray-900"></div> */}
      <p className='font-bold'>--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</p>
      <br/>
      <div className="box flex items-center mb-8 jadoo"> {/* Section 1 */}
        <img src={news1} alt="" className="w-1/2 h-auto mr-4" /> {/* Left aligned image */}
        <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Right aligned text */}
          {/* Text 1 */}
          <p className="text-lg text-center text-[rgb(72,101,146)] pr-4">As per this article by <a href='https://www.indiatoday.in/sunday-special/story/high-rent-crisis-india-real-estate-new-cities-bengaluru-delhi-ncr-mumbai-flats-2529306-2024-04-21'
          rel='nofollow' 
          className='text-blue-500 underline'>India Today</a>, India is facing a severe rent crisis, shattering dreams and aspirations. While house rents remained stagnant during the pandemic, they have skyrocketed since mid-2023. Landlords in several cities are hiking rents by as much as 50% annually, far exceeding the usual 10% increment. This crisis raises questions about the factors contributing to India's housing rent turmoil.
          </p>
        </div>
      </div>
      
      <div className="box flex items-center mb-8 jadoo"> {/* Section 2 */}
        <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Left aligned text */}
          {/* Text 2 */}
          <p className="text-lg text-center text-[rgb(72,101,146)] pl-4"> This article by <a href='https://www.thehindu.com/news/cities/bangalore/there-are-houses-for-rent-in-bengaluru-but-too-many-conditions-apply/article66985129.ece'
          rel='nofollow' 
          className='text-blue-500 underline'>The Hindu</a> shows that despite the availability of rental properties in Bengaluru, many individuals encounter numerous restrictions. Discrimination based on faith, dietary preferences, gender, and occupation often leads to denials for those seeking accommodation in the city.

          </p>
        </div>
        <img src={news2} alt="" className="w-1/2 h-auto ml-4" /> {/* Right aligned image */}
      </div>
      
      <div className="box flex items-center mb-8 jadoo"> {/* Section 3 */}
        <img src={news3} alt="" className="w-1/2 h-auto mr-4" /> {/* Left aligned image */}
        <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Right aligned text */}
          {/* Text 3 */}
          <p className="text-lg text-center text-[rgb(72,101,146)] pr-4">Another article by <a href='https://www.thehindu.com/news/cities/bangalore/house-hunting-gets-tougher-in-bengaluru-thanks-to-hiked-rents-unusual-demands-of-landlords/article66271228.ece'
          rel='nofollow' 
          className='text-blue-500 underline'> The Hindu</a> that house-hunting in Bengaluru has become increasingly challenging due to rising rents and landlords' unusual demands. According to a recent report from No Broker, a property rental and buying portal, rents in Bengaluru have surged by 16.7% in the first half of 2022.</p>
        </div>
      </div>

      <div className="box flex items-center mb-8 jadoo"> {/* Section 4 */}
      <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Centered content with Times New Roman font family */}
      {/* Text 4 */}
      <p className="text-lg text-center text-[rgb(72,101,146)] pl-4"> {/* Increased text size, centered, and color set to RGB(50,98,129) */}
      Another article by <a href='https://economictimes.indiatimes.com/industry/services/property-/-cstruction/housing-rents-up-25-30-in-major-cities-since-2019-report/articleshow/107105316.cms?from=mdr' 
      rel='nofollow' className='text-blue-500 underline'>ETPrime</a> shows that this rise is due to higher demand, limited supply, and inflation. The post-pandemic return to cities has intensified competition for rentals, making housing affordability a critical issue.
      </p>
      </div>
        <img src={news4} alt="" className="w-1/2 h-auto ml-4" /> {/* Right aligned image */}
      </div>
      <br/>
    </div>
  );
};

export default Advertise;
