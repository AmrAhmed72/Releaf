class Plant {
  final int id;
  final String name;
  final String description;
  final String season;
  final String soil;
  final String sunlight;
  final String temperature;
  final String hardinessZones;
  final String soil_ph;
  final String soil_type;
  final String day_sowing;
  final String day_sprout;
  final String day_vegetative;
  final List<dynamic> images;
  final int? categoryId;
  final dynamic category;

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.season,
    required this.soil,
    required this.sunlight,
    required this.temperature,
    required this.hardinessZones,
    required this.soil_ph,
    required this.soil_type,
    required this.day_sowing,
    required this.day_sprout,
    required this.day_vegetative,
    required this.images,
    this.categoryId,
    this.category,
  });
}