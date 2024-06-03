import React from 'react';

const PersonalizedScrollBar = () => {
  return (
    <style jsx global>{`
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      section {
        width: 100%;
        min-height: 100vh;
        padding: 100px;
      }

      ::-webkit-scrollbar {
        width: 12px;
      }

      ::-webkit-scrollbar-thumb {
        background: linear-gradient(transparent, #30ff00);
        border-radius: 6px;
      }

      ::-webkit-scrollbar-thumb:hover {
        background: linear-gradient(transparent, #00c6ff);
        border-radius: 6px;
      }
    `}</style>
  );
};

export default PersonalizedScrollBar;
