import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_match/email_verify.dart';
import 'package:home_match/firebase_options.dart';
import 'package:home_match/home_page.dart';
import 'package:home_match/login.dart';
import 'package:home_match/register.dart';
import 'package:home_match/tag_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      title: 'HomeMatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      home: const RegistrationView(),
      routes: {
        '/homepage/': (context) => HomePage(
              user: FirebaseAuth.instance.currentUser,
            ),
        '/login/': (context) => const Login(),
        '/register/': (context) => const RegistrationView(),
        '/emailverify/': (context) => const EmailVerifyView(),
        '/tags/': (context) => const TagPage(),
      },
    ),
  );
}

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return 
//   }
// }
