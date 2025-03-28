import 'package:flutter/material.dart';

// Keep AddReminderDialog (used by PlantEntry)
class AddReminderDialog extends StatefulWidget {
  const AddReminderDialog({super.key});

  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  bool _isWaterSelected = true;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<bool> _repeatDays = [false, false, false, false, false, false, false];

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
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffEEF0E2),
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
              const Text(
                'Repeat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffC3824D),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50, // Adjust height as needed
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0), // Add spacing between circles
                        child: GestureDetector(
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
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

// ReminderCard widget (unchanged)
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
                // Handle checkbox state change if needed
              },
              activeColor: const Color(0xff609254),
            ),
          ],
        ),
      ),
    );
  }
}

// Optional RemindersScreen as a reusable widget
class RemindersScreen extends StatelessWidget {
  final String selectedDay;
  final VoidCallback onFilterTap;

  const RemindersScreen({
    super.key,
    required this.selectedDay,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onFilterTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.filter_list,
                color: Color(0xff609254),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                selectedDay,
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
        Expanded(
          child: ListView(
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
    );
  }
}