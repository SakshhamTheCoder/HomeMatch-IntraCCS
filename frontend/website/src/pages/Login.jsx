// src/pages/Login.jsx
import { signInWithEmailAndPassword } from "firebase/auth";
import React, { useState } from "react";
import { auth } from "../components/Firebase";
import { toast } from "react-toastify";
import SignInWithGoogle from "./Signin"; // Ensure the case matches
import "react-toastify/dist/ReactToastify.css";

function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await signInWithEmailAndPassword(auth, email, password);
      console.log("User logged in Successfully");
      window.location.href = "../";
      toast.success("User logged in Successfully", {
        position: "top-center",
      });
    } catch (error) {
      console.log(error.message);
      toast.error(error.message, {
        position: "bottom-center",
      });
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 ">
      <div className="max-w-md w-full py-12 px-6 pt-0">
        <div className="text-center">
          <h2 className="text-3xl font-extrabold text-gray-900">WELCOME!</h2>
          <p className="mt-2 text-sm text-gray-600">
            Welcome to Home Match! Please login/register to proceed with our website!
          </p>
        </div>
        <br/>
        <form onSubmit={handleSubmit} className="bg-white p-6 rounded shadow-md">
        <h3 className="text-xl font-bold mb-4">Login</h3>
        <div className="mb-3">
          <label>Email address</label>
          <input
            type="email"
            className="w-full px-3 py-2 border rounded"
            placeholder="Enter email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </div>
        <div className="mb-3">
          <label>Password</label>
          <input
            type="password"
            className="w-full px-3 py-2 border rounded"
            placeholder="Enter password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
        </div>
        <div className="flex justify-center">
          <button type="submit" className="btn btn-primary bg-blue-500 text-white px-4 py-2 rounded">
            Submit
          </button>
        </div>
        <p className="text-right mt-4">
          New User? <a href="/register" className="text-blue-500">Register Here</a>
        </p>
        <SignInWithGoogle />
      </form>
      </div>
    </div>
  );
}

export default Login;
