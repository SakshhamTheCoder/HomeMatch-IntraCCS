// src/pages/Register.jsx
import { createUserWithEmailAndPassword } from "firebase/auth";
import React, { useState } from "react";
import { auth, db } from "../components/Firebase";
import { setDoc, doc } from "firebase/firestore";

function Register() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [fname, setFname] = useState("");
  const [lname, setLname] = useState("");

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      await createUserWithEmailAndPassword(auth, email, password);
      const user = auth.currentUser;
      console.log(user);
      if (user) {
        await setDoc(doc(db, "Users", user.uid), {
          email: user.email,
          firstName: fname,
          lastName: lname,
        });
      }
      console.log("User Registered Successfully!!");
      alert("Registration is successful! Proceed to Login."); // Use JavaScript alert
      window.location.href = "/login"; // Redirect to Login page
    } catch (error) {
      console.log(error.message);
      alert("Error: " + error.message); // Use JavaScript alert for error
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100">
      <form onSubmit={handleRegister} className="bg-white p-6 rounded shadow-md">
        <h3 className="text-xl font-bold mb-4">Sign Up</h3>
        <div className="mb-3">
          <label>First name</label>
          <input
            type="text"
            className="w-full px-3 py-2 border rounded"
            placeholder="First name"
            onChange={(e) => setFname(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <label>Last name</label>
          <input
            type="text"
            className="w-full px-3 py-2 border rounded"
            placeholder="Last name"
            onChange={(e) => setLname(e.target.value)}
          />
        </div>
        <div className="mb-3">
          <label>Email address</label>
          <input
            type="email"
            className="w-full px-3 py-2 border rounded"
            placeholder="Enter email"
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <label>Password</label>
          <input
            type="password"
            className="w-full px-3 py-2 border rounded"
            placeholder="Enter password"
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <div className="flex justify-center">
          <button type="submit" className="btn btn-primary bg-blue-500 text-white px-4 py-2 rounded">
            Sign Up
          </button>
        </div>
        <p className="text-right mt-4">
          Already registered <a href="/login" className="text-blue-500">Login</a>
        </p>
      </form>
    </div>
  );
}

export default Register;
