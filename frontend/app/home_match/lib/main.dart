import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_match/firebase_options.dart';
import 'package:home_match/home_page.dart';
import 'package:home_match/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      title: 'HomeMatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      ),
      home: const Login(),
      routes: {
        '/homepage': (context) => const HomePage(),
        '/login': (context) => const Login(),
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
