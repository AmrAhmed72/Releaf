import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../reminder.dart'; // For AddReminderDialog
import '../../../models/plant.dart';

class GrowingCard extends StatelessWidget {
  final String plantName;
  final Plant plant;
  final String growthStage;
  final String imageUrl;
  final VoidCallback? onAddReminder;

  const GrowingCard({
    super.key,
    required this.plant,
    required this.plantName,
    required this.growthStage,
    required this.imageUrl,
    this.onAddReminder,
  });

  void _showAddReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddReminderDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: const Color(0xffeef0e2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF609254),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Text(
                      'No Image',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                )
                    : const Center(
                  child: Text(
                    'No Image',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff392515),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'soil: ${plant.soil ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff22160d),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (onAddReminder != null) {
                          onAddReminder!();
                        } else {
                          _showAddReminderDialog(context);
                        }
                      },
                      icon: const Icon(Icons.add_alert, size: 18),
                      label: const Text('Add Reminder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff609254),
                        foregroundColor: const Color(0xffeef0e2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}