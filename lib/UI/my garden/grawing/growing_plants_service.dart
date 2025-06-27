import 'package:releaf/models/plant.dart';

class GrowingPlantsService {
  // Singleton instance
  static final GrowingPlantsService _instance = GrowingPlantsService._internal();
  factory GrowingPlantsService() => _instance;
  GrowingPlantsService._internal();

  // List of growing plants
  final List<Plant> _growingPlants = [];

  // Getter for growing plants
  List<Plant> get growingPlants => List.unmodifiable(_growingPlants);

  // Add a plant to growing list if it's not already there
  bool addPlant(Plant plant) {
    if (!_growingPlants.contains(plant)) {
      _growingPlants.add(plant);
      return true;
    }
    return false;
  }
  // Remove a plant from growing list
  bool removePlant(Plant plant) {
    return _growingPlants.remove(plant);
  }

  // Check if a plant is in growing list
  bool isPlantGrowing(Plant plant) {
    return _growingPlants.contains(plant);
  }

  // Clear all growing plants
  void clear() {
    _growingPlants.clear();
  }
}