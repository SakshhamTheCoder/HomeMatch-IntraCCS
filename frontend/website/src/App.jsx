import { createBrowserRouter, RouterProvider, Outlet } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './pages/Home';
import Gallery from './pages/Gallery';
import FAQ from './pages/FAQ';
import About from './pages/About';
import Advertise from './pages/Advertise';



function Layout() {
  return (
    <>
      <Navbar />
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
        element: <Home />
      },
      {
        path: '/gallery',
        element: <Gallery />
      },
      {
        path: '/faq',
        element: <FAQ />
      },
      {
        path: '/about',
        element: <About />
      },
      {
        path: '/advertise',
        element: <Advertise />
      }
    ]
  }
]);


function App({ routes }) {

  return (
    <>
      <RouterProvider router={router} />
    </>
  );
}

export default App;

