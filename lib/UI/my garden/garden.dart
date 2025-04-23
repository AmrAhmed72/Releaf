import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:releaf/UI/my%20garden/planning/planned_plants.dart';
import '../../models/plant.dart';
import 'grawing/grawing card.dart';
import 'grawing/grawing_plants.dart';
import 'reminder.dart'; // For AddReminderDialog and ReminderCard
import 'planning/plan_card.dart'; // For PlanCard

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

  @override
  void initState() {
    super.initState();
    // Check for passed arguments when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        final Plant? plant = args['plant'] as Plant?;
        final String? tab = args['tab'] as String?;
        if (plant != null && tab != null) {
          setState(() {
            if (tab == 'Planning' && !plannedPlants.contains(plant)) {
              plannedPlants.add(plant);
            } else if (tab == 'Growing' && !growingPlants.contains(plant)) {
              growingPlants.add(plant);
            }
            _selectedCategory = tab;
          });
        }
      }
    });
  }

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
        return plannedPlants.isEmpty
            ? const Center(child: Text('No plants planned yet'))
            : ListView.builder(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(1),
          itemCount: plannedPlants.length,
          itemBuilder: (context, index) {
            final plant = plannedPlants[index];
            return Column(
              children: [
                PlanCard(
                  plant: plant,
                  onRemove: () {
                    setState(() {
                      plannedPlants.remove(plant);
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      case "Growing":
        return growingPlants.isEmpty
            ? const Center(child: Text('No plants growing yet'))
            : ListView.builder(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(1),
          itemCount: growingPlants.length,
          itemBuilder: (context, index) {
            final plant = growingPlants[index];
            return Column(
              children: [
                GrowingCard(
                  plantName: plant.name,
                  growthStage: 'Vegetative', // Placeholder, adjust as needed
                  imageUrl:
                  plant.imageUrls.isNotEmpty ? plant.imageUrls.first : '',
                ),
                const SizedBox(height: 16),
              ],
            );
          },
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
            minChildSize: 0.7,
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
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
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
                                Container(
                                  height: 3, // Increased for bolder line
                                  width: 55,
                                  color: _selectedCategory == "Planning"
                                      ? const Color(0xff609254)
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = "Growing";
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
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
                                Container(
                                  height: 3, // Increased for bolder line
                                  width: 55,
                                  color: _selectedCategory == "Growing"
                                      ? const Color(0xff609254)
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = "Reminders";
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
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
                                Container(
                                  height: 3, // Increased for bolder line
                                  width: 70,
                                  color: _selectedCategory == "Reminders"
                                      ? const Color(0xff609254)
                                      : Colors.transparent,
                                ),
                              ],
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