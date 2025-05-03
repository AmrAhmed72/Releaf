import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String title;
  final String plantName;
  final String description;
  final IconData icon;
  final VoidCallback? onCheck;

  const ReminderCard({
    super.key,
    required this.title,
    required this.plantName,
    required this.description,
    required this.icon,
    this.onCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xffeef0e2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xff609254),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff609254),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plantName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff392515),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: false,
              onChanged: (bool? value) {
                if (onCheck != null) onCheck!();
              },
              activeColor: const Color(0xff609254),
            ),
          ],
        ),
      ),
    );
  }
}
