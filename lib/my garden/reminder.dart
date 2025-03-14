import 'package:flutter/material.dart';

import 'planing.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  String _selectedDay = "Monday"; // Default selected day

  // List of weekdays
  final List<String> _weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  // Function to show the weekday selection dialog
  void _showWeekdaySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xfff4f5ec), // Set background color to #F4F5EC
          title: const Text(
            "Select a Day",
            style: TextStyle(
              color: Color(0xff392515),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _weekdays.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _weekdays[index],
                    style: const TextStyle(
                      color: Color(0xff392515),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedDay = _weekdays[index];
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/Rectangle 52.png",
            fit: BoxFit.cover,
          ),
          // Draggable sheet
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (context, controller) => ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                color: const Color(0xfff4f5ec),
                child: Padding(
                  padding: const EdgeInsets.all(15.0), // 15px padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Navigation row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PlanningScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Planning",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff392515),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Growing",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff392515),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const Text(
                            "Reminders",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff609254),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Weekday header with filter icon (now tappable)
                      GestureDetector(
                        onTap: _showWeekdaySelectionDialog,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: Color(0xff609254),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _selectedDay, // Dynamically updated day
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff609254),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Reminder cards
                      Expanded(
                        child: ListView(
                          controller: controller,
                          children: const [
                            ReminderCard(
                              title: 'Water',
                              plantName: 'Radish!',
                              description: 'Radish is to be watered at 8 am',
                              icon: Icons.water_drop,
                            ),
                            SizedBox(height: 16),
                            ReminderCard(
                              title: 'Fertilize',
                              plantName: 'Onions!',
                              description: 'Onions is to be fertilized at 8 am',
                              icon: Icons.local_florist,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReminderCard extends StatelessWidget {
  final String title;
  final String plantName;
  final String description;
  final IconData icon;

  const ReminderCard({
    super.key,
    required this.title,
    required this.plantName,
    required this.description,
    required this.icon,
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
                // Handle checkbox state change
              },
              activeColor: const Color(0xff609254),
            ),
          ],
        ),
      ),
    );
  }
}