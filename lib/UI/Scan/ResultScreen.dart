import 'dart:io';
import 'package:flutter/material.dart';

// Screen to display both primary and secondary identification results
class ResultScreen extends StatelessWidget {
  final String flowerInfoPrimary;
  final String flowerInfoSecondary;
  final String imagePath;

  const ResultScreen({
    super.key,
    required this.flowerInfoPrimary,
    required this.flowerInfoSecondary,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF609254),
        title: const Text("Identification Result"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(File(imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display the primary flower identification
            Text(
              "Primary Identification",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF609254),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              flowerInfoPrimary,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // Display the secondary flower identification
            Text(
              "Secondary Identification",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF609254),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              flowerInfoSecondary,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}