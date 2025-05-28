import 'package:flutter/material.dart';
import 'dart:io';
import 'package:scanning_effect/scanning_effect.dart';

class ScanningAnimation extends StatefulWidget {
  final String imagePath;

  const ScanningAnimation({super.key, required this.imagePath});

  @override
  State<ScanningAnimation> createState() => _ScanningAnimationState();
}

class _ScanningAnimationState extends State<ScanningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller for the text
    _textAnimationController = AnimationController(
      duration: const Duration(seconds: 1), // Duration of one fade cycle
      vsync: this,
    )..repeat(reverse: true); // Repeat the animation, reversing direction

    // Define the opacity animation (0.0 = fully transparent, 1.0 = fully opaque)
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: const Color(0xFFF4F5EC),
        child: Stack(
          children: [
            // Display the image being scanned
            Positioned.fill(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            // Scanning effect with shadow
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ScanningEffect(
                scanningColor: Colors.green,
                borderLineColor: Colors.green,
                delay: const Duration(seconds: 0),
                duration: const Duration(seconds: 2),
                scanningHeightOffset: 0.7,
                scanningLinePadding: EdgeInsets.all(0),
                enableBorder: false,
                child: const SizedBox(),
              ),
            ),
            // Animated "Scanning..." text
            Center(
              child: FadeTransition(
                opacity: _textAnimation,
                child: const Text(
                  "Scanning...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}