import 'package:flutter/material.dart';
import 'package:home_match/home.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'HomeMatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
      routes: {},
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
