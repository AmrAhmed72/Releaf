import '../../../models/plant.dart';
import 'growing_plants_service.dart';

// Get the growing plants list from the service
List<Plant> get growingPlants => GrowingPlantsService().growingPlants;