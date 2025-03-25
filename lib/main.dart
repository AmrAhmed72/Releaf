import 'package:flutter/material.dart';
import 'package:releaf/SplashScreen.dart';
import 'package:releaf/UI/Home/homepage.dart';
import 'package:releaf/UI/signup/SignUpScreen.dart';
import 'UI/Home/PlantDetailScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      ),
      //home: Homepage(),
      //home: PlantDetailScreen(),
        home:SplashScreen(),
    );
  }
}

