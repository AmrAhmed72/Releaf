import 'package:flutter/material.dart';
import 'package:releaf/SplashScreen.dart';
import 'package:releaf/UI/signup/SignUpScreen.dart';
import 'package:releaf/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      //home: Homepage(),
      home: const SplashScreen(),
    );
  }
}
