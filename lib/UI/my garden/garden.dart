import 'package:flutter/material.dart';
import 'reminder.dart'; // For AddReminderDialog and ReminderCard
import 'planing.dart'; // For PlanCard

class MyGarden extends StatefulWidget {
  const MyGarden({super.key});

  @override
  _MyGardenState createState() => _MyGardenState();
}

class _MyGardenState extends State<MyGarden> {
  String _selectedCategory = "Growing"; // Default category
  String _selectedDay = "Monday"; // For Reminders section

  // List of weekdays for Reminders
  final List<String> _weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  // Function to show the weekday selection dialog for Reminders
  void _showWeekdaySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF4F5EC),
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
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Method to build the content based on the selected category
  Widget _buildContent(ScrollController controller) {
    switch (_selectedCategory) {
      case "Planning":
        return ListView(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          children: const [
            PlanCard(
              imagePath: 'assets/sweet_basil.png',
              plantName: 'Sweet Basil',
              season: 'summer',
            ),
            SizedBox(height: 16),
            PlanCard(
              imagePath: 'assets/potato.png',
              plantName: 'Potato',
              season: 'summer',
            ),
            SizedBox(height: 16),
            PlanCard(
              imagePath: 'assets/yarrow.png',
              plantName: 'Yarrow',
              season: 'summer',
            ),
          ],
        );
      case "Growing":
        return ListView(
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
        );
      case "Reminders":
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _showWeekdaySelectionDialog,
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
                    _selectedDay,
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
        );
      default:
        return const SizedBox.shrink();
    }
  }

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
                              setState(() {
                                _selectedCategory = "Planning";
                              });
                            },
                            child: Text(
                              "Planning",
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedCategory == "Planning"
                                    ? const Color(0xff609254)
                                    : const Color(0xff392515),
                                fontWeight: _selectedCategory == "Planning"
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = "Growing";
                              });
                            },
                            child: Text(
                              "Growing",
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedCategory == "Growing"
                                    ? const Color(0xff609254)
                                    : const Color(0xff392515),
                                fontWeight: _selectedCategory == "Growing"
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = "Reminders";
                              });
                            },
                            child: Text(
                              "Reminders",
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedCategory == "Reminders"
                                    ? const Color(0xff609254)
                                    : const Color(0xff392515),
                                fontWeight: _selectedCategory == "Reminders"
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _buildContent(controller),
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

// PlantEntry class
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
                        _showAddReminderDialog(context);
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