import 'package:flutter/material.dart';
import 'reminder.dart'; // Existing import
import 'planing.dart'; // New import for PlanningScreen

class MyGarden extends StatelessWidget {
  const MyGarden({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/Rectangle 52.png",
            fit: BoxFit.cover,
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.1,
            maxChildSize: 1,
            builder: (context, controller) => ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                color: const Color(0xfff4f5ec),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          const Text(
                            "Growing",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff609254),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RemindersScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Reminders",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff392515),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          controller: controller,
                          children: const [
                            PlantEntry(
                              plantName: 'Onions',
                              growthStage: 'Vegetative',
                              imagePath: 'assets/Rectangle 67.png',
                            ),
                            SizedBox(height: 16),
                            PlantEntry(
                              plantName: 'Maize',
                              growthStage: 'Flowering',
                              imagePath: 'assets/Rectangle 68.png',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Add button pressed");
        },
        backgroundColor: const Color(0xff609254),
        child: const Icon(
          Icons.add,
          color: Color(0xffeef0e2),
          size: 30,
        ),
      ),
    );
  }
}

class PlantEntry extends StatelessWidget {
  final String plantName;
  final String growthStage;
  final String imagePath;

  const PlantEntry({
    super.key,
    required this.plantName,
    required this.growthStage,
    required this.imagePath,
  });

  // Function to show the Add Reminder dialog
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
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
                    'Growth stage: $growthStage',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showAddReminderDialog(context); // Show dialog on press
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

// Custom dialog widget for adding reminders
// Custom dialog widget for adding reminders
class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({super.key});

  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  bool _isWaterSelected = true; // Default to Water
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<bool> _repeatDays = [false, false, false, false, false, false, false]; // M T W T F S S

  // Function to pick a date
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to pick a time
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent, // Make Dialog background transparent
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffEEF0E2), // Set background color to #EEF0E2
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Add Reminder',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffC3824D),
                ),
              ),
              const SizedBox(height: 16),
              // Water and Fertilize toggle buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChoiceChip(
                    label: const Text('Water'),
                    selected: _isWaterSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _isWaterSelected = true;
                      });
                    },
                    selectedColor: const Color(0xff609254),
                    backgroundColor: const Color(0xffEEF0E2),
                    labelStyle: TextStyle(
                      color: _isWaterSelected ? Colors.white : Colors.black,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('Fertilize'),
                    selected: !_isWaterSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        _isWaterSelected = false;
                      });
                    },
                    selectedColor: const Color(0xff609254),
                    backgroundColor: const Color(0xffEEF0E2),
                    labelStyle: TextStyle(
                      color: !_isWaterSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Date and Time selection
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0x4d9f8571),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Date: ${_selectedDate.day.toString().padLeft(2, '0')} ${_selectedDate.month.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, color: Color(0xff609254)),
                          onPressed: () => _pickDate(context),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time: ${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time, color: Color(0xff609254)),
                          onPressed: () => _pickTime(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Repeat days selection
              const Text(
                'Repeat',
                style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                  color: Color(0xffC3824D),),

              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (index) {
                  final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _repeatDays[index] = !_repeatDays[index];
                      });
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: _repeatDays[index]
                          ? const Color(0xff609254)
                          : const Color(0xffe0e0e0),
                      child: Text(
                        days[index],
                        style: TextStyle(
                          color: _repeatDays[index] ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              // Done button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the reminder saving logic here
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff609254),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}