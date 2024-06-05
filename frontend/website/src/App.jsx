// src/App.jsx
import { createBrowserRouter, RouterProvider, Outlet } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import FAQ from './pages/FAQ';
import About from './pages/About';
import Advertise from './pages/Advertise';
import Footer from './components/Footer';
import Scrollbar from './components/Scrollbar';
import Explore from './pages/Explore';

function Layout() {
  return (
    <>
      <Navbar />
      <Footer />
      <Scrollbar />
      <Outlet />
    </>
  );
}

const router = createBrowserRouter([
  {
    element: <Layout />,
    children: [
      {
        path: '/',
        element: <Home />,
      },
      {
        path: '/faq',
        element: <FAQ />,
      },
      {
        path: '/about',
        element: <About />,
      },
      {
        path: '/advertise',
        element: <Advertise />,
      },
      {
        path: '/explore',
        element: <Explore />,
      },
    ],
  },
]);

function App({ routes }) {
  return (
    <>
      <RouterProvider router={router} />
    </>
  );
}

export default App;
