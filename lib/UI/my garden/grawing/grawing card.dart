import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/plant.dart';
import '../reminder/reminder.dart';
import '../reminder/reminer_utils.dart';

class GrowingCard extends StatelessWidget {
  final String plantName;
  final Plant plant;
  final String soil;
  final String imageUrl;
  final VoidCallback? onAddReminder;
  final VoidCallback? onRemove; // New callback for remove action

  const GrowingCard({
    super.key,
    required this.plant,
    required this.plantName,
    required this.soil,
    required this.imageUrl,
    this.onAddReminder,
    this.onRemove, // Added to constructor
  });

  void _showAddReminderDialog(BuildContext context) {
    showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return const AddReminderDialog();
      },
    ).then((result) {
      if (result != null) {
        reminders.add(Reminder(
          plant: plant,
          type: result['type'],
          dateTime: result['dateTime'],
          repeatDays: result['repeatDays'].cast<bool>(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xff4C2B12),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Card(
        color: const Color(0xffeef0e2),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top content
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 21, bottom: 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 80,
                      height: 80,
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18, top: 18.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plantName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff4C2B12),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text(
                                'Soil:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff4c2b12),
                                ),
                              ),
                              Text(
                                ' $soil',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xff22160d),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'remove') {
                        onRemove?.call(); // Call the remove callback
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'remove',
                        child: Text('Remove'),
                      ),
                    ],
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xff39ad4e),
                      size: 20,
                    ),
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
            ),
            // Full-width divider
            const Divider(
              color: Color(0xff4c2b12),
              thickness: 0.5,
              height: 0,
            ),
            // Centered "add reminder" section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  if (onAddReminder != null) {
                    onAddReminder!();
                  } else {
                    _showAddReminderDialog(context);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 110),
                  child: Row(
                    children: [
                      Icon(
                        Icons.alarm_add,
                        size: 14,
                        color: Color(0xff39ad4e),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'add reminder',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff39ad4e),
                        ),
                      ),
                    ],
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