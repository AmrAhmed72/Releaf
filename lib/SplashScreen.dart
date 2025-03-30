import 'package:flutter/material.dart';
import 'package:releaf/UI/Home/homepage.dart'; // Import your existing homepage
import 'dart:async';






class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<Offset> _logoPosition;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller (2.5 seconds total)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Define animations
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeIn)),
    );
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
    );
    _logoPosition = Tween<Offset>(
      begin: const Offset(0.0, -0.2), // Start above center
      end: const Offset(0.0, 0.0),   // Move to center to align with Releaf.png
    ).animate(CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.6, curve: Curves.easeInOut)));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)),
    );

    // Start the animation
    _controller.forward();

    // Navigate to Homepage after 2.5 seconds
    Timer(const Duration(milliseconds: 2800), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Homepage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC), // Updated background color
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Standalone logo animates in, scales, and moves, then disappears
                Opacity(
                  opacity: 1.0 - _textOpacity.value, // Fade out as text fades in
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Transform.translate(
                      offset: _logoPosition.value,
                      child: Image.asset(
                        'assets/logo.png', // Your standalone logo
                        width: 230, // Larger logo as per your previous request
                        height: 230, // Larger logo
                        fit: BoxFit.contain, // Preserve clarity
                        filterQuality: FilterQuality.high, // Improve rendering
                      ),
                    ),
                  ),
                ),
                // Releaf with logo fades in (larger size)
                Opacity(
                  opacity: _textOpacity.value,
                  child: Image.asset(
                    'assets/Releaf.png', // Full word with logo integrated
                    width: 420, // Updated size as per your decoration
                    height: 420, // Updated size as per your decoration
                    fit: BoxFit.contain, // Preserve clarity
                    filterQuality: FilterQuality.high, // Improve rendering
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}