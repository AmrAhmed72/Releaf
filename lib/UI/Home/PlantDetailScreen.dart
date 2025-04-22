import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/plant.dart';
import '../my garden/grawing/grawing_plants.dart';
import '../my garden/planning/planned_plants.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35),
        child: AppBar(
          backgroundColor: const Color(0xFFF4F5EC),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            plant.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      backgroundColor: const Color(0xFFF4F5EC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Image
            Container(
              height: 210,
              width: double.infinity,
              child: plant.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: plant.imageUrls.first,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF609254),
                  ),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Text(
                    'No Image Available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
                  : const Center(
                child: Text(
                  'No Image Available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                plant.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Description Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                plant.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Conditions Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Conditions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ConditionRow(
                    icon: Icons.thermostat,
                    label: 'Temperature',
                    value: plant.temperature,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.wb_sunny,
                    label: 'Sunlight',
                    value: plant.sunlight,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.spa,
                    label: 'Soil',
                    value: plant.soil,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.landscape,
                    label: 'Hardiness Zones',
                    value: plant.hardinessZones,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.water_drop,
                    label: 'Soil pH',
                    value: plant.soil_ph,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.terrain,
                    label: 'Soil Type',
                    value: plant.soil_type,
                  ),
                ],
              ),
            ),
            // Growth Timeline Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Growth Timeline',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ConditionRow(
                    icon: Icons.calendar_today,
                    label: 'Sowing',
                    value: plant.day_sowing,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.local_florist,
                    label: 'Sprouting',
                    value: plant.day_sprout,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.local_florist,
                    label: 'Vegetative Growth',
                    value: plant.day_vegetative,
                  ),
                ],
              ),
            ),
            // Season Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Season',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConditionRow(
                icon: Icons.event,
                label: 'Season',
                value: plant.season,
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Add plant to plannedPlants if not already added
                        if (!plannedPlants.contains(plant)) {
                          plannedPlants.add(plant);
                        }
                        // Show popup dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFF4F5EC),
                              title: const Text(
                                'Success',
                                style: TextStyle(
                                  color: Color(0xff392515),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                '${plant.name} added to Planning!',
                                style: const TextStyle(
                                  color: Color(0xff392515),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                    // Navigate to MyGarden with the plant
                                    Navigator.pushNamed(
                                      context,
                                      '/my_garden',
                                      arguments: {'plant': plant, 'tab': 'Planning'},
                                    );
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Color(0xff609254),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Planning to grow 🌱',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add plant to growingPlants if not already added
                      if (!growingPlants.contains(plant)) {
                        growingPlants.add(plant);
                      }
                      // Show popup dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFF4F5EC),
                            title: const Text(
                              'Success',
                              style: TextStyle(
                                color: Color(0xff392515),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              '${plant.name} added to Growing!',
                              style: const TextStyle(
                                color: Color(0xff392515),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                  // Navigate to MyGarden with the plant
                                  Navigator.pushNamed(
                                    context,
                                    '/my_garden',
                                    arguments: {'plant': plant, 'tab': 'Growing'},
                                  );
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xff609254),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF51B661),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Growing it 🌿',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
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

class ConditionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ConditionRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 24.0),
              const SizedBox(width: 12.0),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}