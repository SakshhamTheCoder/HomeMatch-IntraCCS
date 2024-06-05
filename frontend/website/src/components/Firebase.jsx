// src/components/Firebase.jsx
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyD2iDXLFpTIgD3N8frjANl8kOasDOLjhTo",
  authDomain: "login-auth-bd6ba.firebaseapp.com",
  projectId: "login-auth-bd6ba",
  storageBucket: "login-auth-bd6ba.appspot.com",
  messagingSenderId: "420866143860",
  appId: "1:420866143860:web:1e52cb51568c21ad6d4321"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth();
export const db = getFirestore(app);
export default app;
