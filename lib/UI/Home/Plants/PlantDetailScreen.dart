import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/plant.dart';
import '../../../services/growing_plants_service.dart';
import '../../my garden/planning/planned_plants.dart';

class PlantDetailScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    final isGrowing = GrowingPlantsService().isPlantGrowing(plant);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          backgroundColor: const Color(0xFFF4F5EC),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xff392515)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            plant.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff392515),
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
              padding: const EdgeInsets.all(16),
              child: Text(
                plant.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Color(0xff392515)),
              ),
            ),
            // Description Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff392515)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                plant.description,
                style: const TextStyle(fontSize: 16,color: Color(0xff392515)),
              ),
            ),
            // Conditions Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Conditions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff392515)),
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
                    icon: Icons.water_drop,
                    label: 'Soil pH',
                    value: plant.soil_ph,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.sunny_snowing,
                    label: 'Soil Type',
                    value: plant.soil_type,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.landscape,
                    label: 'Hardiness Zones',
                    value: plant.hardinessZones,
                  ),
                ],
              ),
            ),
            // Growth Timeline Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Growth Timeline',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff392515)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ConditionRow(
                    icon:  Icons.spa_outlined,
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
                    icon: Icons.local_florist_outlined,
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Color(0xff392515)),
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
                        if (!plannedPlants.contains(plant)) {
                          plannedPlants.add(plant);
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFEEF0E2),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 162,
                                    height: 142,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xffeef0e2),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xffc3824d),
                                            width: 5.2,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Color(0xffc3824d),
                                            size: 70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Add to planning',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffc3824d),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
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
                            style: TextStyle(fontSize: 15,color: Color(0xff392515)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: isGrowing
                        ? null // Disable button if already growing
                        : () {
                      if (GrowingPlantsService().isPlantGrowing(plant)) {
                        // Show message that plant is already growing
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFEEF0E2),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 162,
                                    height: 142,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xffeef0e2),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xffc3824d),
                                            width: 5.2,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.info,
                                            color: Color(0xffc3824d),
                                            size: 70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Already Growing',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffc3824d),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        // Add the plant and show success message
                        GrowingPlantsService().addPlant(plant);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: const Color(0xFFEEF0E2),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 162,
                                    height: 142,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: const Color(0xffeef0e2),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xffc3824d),
                                            width: 5.2,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: Color(0xffc3824d),
                                            size: 70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Add to Growing',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xffc3824d),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isGrowing ? Colors.grey[400] : const Color(0xFF51B661),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isGrowing ? 'Growing 🌿' : 'Growing it 🌿',
                          style: const TextStyle(fontSize: 15, color: Color(0xFFF4F5EC)),
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