// tailwind.config.js
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors:{
        customBlack: 'rgb(200,204,153)'
      }
    },
  },
  plugins: [],
};
