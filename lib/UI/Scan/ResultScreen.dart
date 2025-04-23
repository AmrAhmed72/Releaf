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
      backgroundColor: Color(0xffeef0e2),
      appBar: AppBar(
        backgroundColor: const Color(0xffeef0e2),
        elevation: 0,
        title: const Text(
          'Identification Result',
          style: TextStyle(
            color: Color(0xff392515),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff392515)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image
            Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: FileImage(File(imagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display the primary flower identification
            Text(
              "Identification Name : ",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF609254),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              flowerInfoPrimary,
              style: const TextStyle(
                fontSize: 19,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            // Display the secondary flower identification
            Text(
              "Description : ",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF609254),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              flowerInfoSecondary,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}