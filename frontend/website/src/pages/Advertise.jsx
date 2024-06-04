import React from 'react';
import news1 from '../assets/news1.jpeg';
import news2 from '../assets/news2.jpeg';
import news3 from '../assets/news3.jpeg';
import news4 from '../assets/news4.jpeg';
import Building from '../assets/building.png';
import Home from '../assets/home.png';
import Group from '../assets/group.png';


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
          <p className="text-lg text-center text-[rgb(72,101,146)] pr-4">As per this article by <a href='https://www.theguardian.com/us-news/2023/may/10/us-housing-market-prices-increasing' rel='nofollow' 
          className='text-blue-500 underline'>The Guardian</a>, USA is facing a severe housing crisis, shattering dreams and aspirations. While house rents remained stagnant during the pandemic, they have skyrocketed since mid-2023. Landlords in several cities are hiking rents by as much as 50% annually, far exceeding the usual 10% increment. This crisis raises questions about the factors contributing to USA's housing  turmoil.
          </p>
        </div>
      </div>
      
      <div className="box flex items-center mb-8 jadoo"> {/* Section 2 */}
        <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Left aligned text */}
          {/* Text 2 */}
          <p className="text-lg text-center text-[rgb(72,101,146)] pl-4"> This article by <a href='https://www.npr.org/2024/01/25/1225957874/housing-unaffordable-for-record-half-all-u-s-renters-study-finds'
          rel='nofollow' 
          className='text-blue-500 underline'>NPR</a> shows that despite the availability of rental properties in Bengaluru, many individuals encounter numerous restrictions. Discrimination based on faith, dietary preferences, gender, and occupation often leads to denials for those seeking accommodation in the city.

          </p>
        </div>
        <img src={news2} alt="" className="w-1/2 h-auto ml-4" /> {/* Right aligned image */}
      </div>
      
      <div className="box flex items-center mb-8 jadoo"> {/* Section 3 */}
        <img src={news3} alt="" className="w-1/2 h-auto mr-4" /> {/* Left aligned image */}
        <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Right aligned text */}
          {/* Text 3 */}
          <p className="text-lg text-center text-[rgb(72,101,146)] pr-4">Another article by <a href='https://edition.cnn.com/2023/07/14/homes/build-for-rent-homes/index.html' rel='nofollow' 
          className='text-blue-500 underline'> CNN</a> that house-hunting in Bengaluru has become increasingly challenging due to rising rents and landlords' unusual demands. According to a recent report from No Broker, a property rental and buying portal, rents in Bengaluru have surged by 16.7% in the first half of 2022.</p>
        </div>
      </div>

      <div className="box flex items-center mb-8 jadoo"> {/* Section 4 */}
      <div className="w-1/2 flex flex-col items-center justify-center font-serif"> {/* Centered content with Times New Roman font family */}
      {/* Text 4 */}
      <p className="text-lg text-center text-[rgb(72,101,146)] pl-4"> {/* Increased text size, centered, and color set to RGB(50,98,129) */}
      Another article by <a href='https://www.americanprogress.org/article/the-rental-housing-crisis-is-a-supply-problem-that-needs-supply-solutions/' rel='nofollow' className='text-blue-500 underline'>American Progress</a> shows that this rise is due to higher demand, limited supply, and inflation. The post-pandemic return to cities has intensified competition for rentals, making housing affordability a critical issue.
      </p>
      </div>
        <img src={news4} alt="" className="w-1/2 h-auto ml-4" /> {/* Right aligned image */}
      </div>
      <br/>
      <p className='font-bold'>--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</p>
      <br/>
      {/* Heading: Why choose HomeMatch */}
      <h1 className="text-3xl font-semibold text-[rgb(87,39,123)] mb-4">But Why Choose HomeMatch?</h1>

      {/* Heading: BENEFITS OF Homematch */}
      <h2 className="text-3xl text-[#8993A4] font-open-sans text-[14px] spacer4 textC font-semibold mb-4">BENEFITS OF HOME MATCH</h2>


      {/* Icon and Content Divs */}
      <div className="flex justify-between w-full mb-8">
        {/* Div 1 */}
        <div className="flex flex-col items-center justify-center pl-5">
        <img src={Building} alt="" className="w-16 h-16 mb-4" /> {/* Image */}
        <div className="text-center "> {/* Center aligned text */}
        <p className='text-lg font-semibold text-blue-600 '>Huge Amount of Properties</p> {/* First paragraph */}
        <p className='pl-1 text-[16px] text-[#5f6571] '>Thousands of new properties are being added everyday!</p> {/* Second paragraph */}
        </div>
</div>

        {/* Div 2 */}
        <div className="flex flex-col pr-00 pl-20 right-0 items-center justify-center">
          <img src={Home} alt="" className="w-16 h-16 mb-4" /> {/* Icon */}
          <div className="text-center ">
          <p className="text-lg font-semibold  text-blue-600 ">Verification by Home Match Team</p> 
            <p className='text-[16px] text-[#5f6571]'>Properties provided tailored to individual needs.</p>{/* Content */}
          </div>
          
        </div>

        {/* Div 3 */}
        <div className="flex flex-col items-center justify-center pr-6">
        <img src={Group} alt="" className="w-16 h-16 mb-4" />{/* Icon */}
        <div className='text-center'>
        <p className="text-lg text-blue-600 font-semibold">Large User Base</p>
            <p className='text-[16px] text-[#5f6571]'>
              High active user count and user engagement to find and close deals
            </p> {/* Content */}
        </div>
          
        </div>
      </div>
      <br/>
      <br/>
    </div>
  );
};

export default Advertise;
