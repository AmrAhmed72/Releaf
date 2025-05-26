import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<String>? results; // For identification results (indices 0-5)
  final String? flowerInfoPrimary; // For diagnosis results
  final String? flowerInfoSecondary; // For diagnosis results
  final String imagePath;
  final bool isDiagnosis;

  const ResultScreen({
    super.key,
    this.results,
    this.flowerInfoPrimary,
    this.flowerInfoSecondary,
    required this.imagePath,
    this.isDiagnosis = false,
  });

  @override
  Widget build(BuildContext context) {
    // Define labels for identification results
    const List<String> labels = [
      'Flower Name:',
      'Scientific Name:',
      'Genus:',
      'Fun Fact:',
      'Where Found:',
      'Description:',
    ];

    return Scaffold(
      backgroundColor: const Color(0xffeef0e2),
      appBar: AppBar(
        backgroundColor: const Color(0xffeef0e2),
        elevation: 0,
        title: Text(
          isDiagnosis ? 'Diagnosis Result' : 'Identification Result',
          style: const TextStyle(
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
            if (isDiagnosis) ...[
              Text(
                'Disease Name:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF609254),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                flowerInfoPrimary ?? 'Unknown',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: Color(0xFF4C2B12),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF609254),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                flowerInfoSecondary ?? 'No description available',
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                ),
              ),
            ] else ...[
              // Display identification results with specific labels
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  results?.length ?? 0,
                      (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labels[index],
                          style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF609254),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          results![index],
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            color: Color(0xFF4C2B12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}