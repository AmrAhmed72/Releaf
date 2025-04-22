import 'package:flutter/material.dart';
import 'package:releaf/UI/my%20garden/planning/planned_plants.dart';
import '../../../models/plant.dart';
import './plan_card.dart';

class PlanningScreen extends StatefulWidget {
  const PlanningScreen({super.key});

  @override
  _PlanningScreenState createState() => _PlanningScreenState();
}

class _PlanningScreenState extends State<PlanningScreen> {
  @override
  void initState() {
    super.initState();
    // Check for passed Plant argument when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Plant? plant = ModalRoute.of(context)?.settings.arguments as Plant?;
      if (plant != null && !plannedPlants.contains(plant)) {
        setState(() {
          plannedPlants.add(plant);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(15.0),
      itemCount: plannedPlants.length,
      itemBuilder: (context, index) {
        final plant = plannedPlants[index];

      },
    );
  }
}