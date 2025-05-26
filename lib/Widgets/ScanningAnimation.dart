import 'package:flutter/material.dart';
import 'dart:io';

class ScanningAnimation extends StatefulWidget {
  final String imagePath;

  const ScanningAnimation({super.key, required this.imagePath});

  @override
  State<ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Color(0xFFF4F5EC), // Solid black background
        child: Stack(
          children: [
            // Display the image being scanned
            Positioned.fill(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            // Scanning bar
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: _animation.value * 400, // Adjusted for dialog height
                      child: Container(
                        height: 4,
                        color: Colors.green.withOpacity(0.7),
                        child: const Center(),
                      ),
                    ),
                    // Scanning text
                    const Center(
                      child: Text(
                        "Scanning...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}