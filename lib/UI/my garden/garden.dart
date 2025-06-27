import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:releaf/UI/my%20garden/planning/planned_plants.dart';
import 'package:releaf/UI/my%20garden/reminder/reminder_card.dart';
import 'package:releaf/UI/my%20garden/reminder/reminer_utils.dart';
import '../../models/plant.dart';
import 'grawing/grawing card.dart';
import 'grawing/grawing_plants.dart';
import 'planning/plan_card.dart';
import 'grawing/growing_plants_service.dart'; // Added import

class MyGarden extends StatefulWidget {
  const MyGarden({super.key});

  @override
  _MyGardenState createState() => _MyGardenState();
}

class _MyGardenState extends State<MyGarden> {
  String _selectedCategory = "Growing";
  String _selectedDay = "Monday";

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        final Plant? plant = args['plant'] as Plant?;
        final String? tab = args['tab'] as String?;
        if (plant != null && tab != null) {
          setState(() {
            if (tab == 'Planning' && !plannedPlants.contains(plant)) {
              plannedPlants.add(plant);
            } else if (tab == 'Growing' &&
                !GrowingPlantsService().isPlantGrowing(plant)) {
              GrowingPlantsService().addPlant(plant);
            }
            _selectedCategory = tab;
          });
        }
      }
    });
  }

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

  void _deleteReminder(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  Widget _buildContent(ScrollController controller) {
    switch (_selectedCategory) {
      case "Planning":
        return plannedPlants.isEmpty
            ? const Center(child: Text('No plants planned yet'))
            : ListView.builder(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
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
        final growingPlants = GrowingPlantsService().growingPlants;
        return growingPlants.isEmpty
            ? const Center(child: Text('No plants growing yet'))
            : ListView.builder(
          controller: controller,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          itemCount: growingPlants.length,
          itemBuilder: (context, index) {
            final plant = growingPlants[index];
            return Column(
              children: [
                GrowingCard(
                  plantName: plant.name,
                  plant: plant,
                  soil: plant.soil,
                  imageUrl:
                  plant.imageUrls.isNotEmpty ? plant.imageUrls.first : '',
                  onRemove: () {
                    setState(() {
                      GrowingPlantsService().removePlant(plant);
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      case "Reminders":
        final filteredReminders = reminders.where((reminder) {
          final dayIndex = [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ].indexOf(_selectedDay);
          return reminder.repeatDays[dayIndex];
        }).toList();
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
              child: ListView.builder(
                controller: controller,
                itemCount: filteredReminders.length,
                itemBuilder: (context, index) {
                  final reminder = filteredReminders[index];
                  return ReminderCard(
                    title: reminder.type == 'water' ? 'Water' : 'Fertilize',
                    plantName: reminder.plant.name,
                    description:
                    '${reminder.plant.name} is to be ${reminder.type == 'water' ? 'watered' : 'fertilized'} at ${reminder.dateTime.hour.toString().padLeft(2, '0')}:${reminder.dateTime.minute.toString().padLeft(2, '0')} on ${reminder.dateTime.day}/${reminder.dateTime.month}/${reminder.dateTime.year}',
                    icon: reminder.type == 'water'
                        ? Icons.water_drop
                        : Icons.local_florist,
                    onCheck: () => _deleteReminder(reminders.indexOf(reminder)),
                  );
                },
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
    return SafeArea(
      child: Scaffold(
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
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(30)),
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
      ),
    );
  }
}