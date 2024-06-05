import { GoogleAuthProvider, signInWithPopup } from "firebase/auth";
import { auth, db } from "../components/Firebase";
import { toast } from "react-toastify";
import { setDoc, doc } from "firebase/firestore";
// import googleLogo from "../assets/google.png"; // Use import for image

function SignInWithGoogle() {
  const googleLogin = async () => {
    try {
      const provider = new GoogleAuthProvider();
      const result = await signInWithPopup(auth, provider);
      const user = result.user;
      if (user) {
        await setDoc(doc(db, "Users", user.uid), {
          email: user.email,
          firstName: user.displayName,
          photo: user.photoURL,
          lastName: "",
        });
        toast.success("User logged in Successfully", {
          position: "top-center",
        });
        window.location.href = "../";
      }
    } catch (error) {
      console.error(error.message);
      toast.error(error.message, {
        position: "bottom-center",
      });
    }
  };

  return (
    <div>
      {/* <p className="continue-p">--Or continue with--</p> */}
      <div
        style={{ display: "flex", justifyContent: "center", cursor: "pointer" }}
        onClick={googleLogin}
      >
        {/* <img src={googleLogo} width={"60%"} alt="Google sign-in" /> */}
      </div>
    </div>
  );
}

export default SignInWithGoogle;
