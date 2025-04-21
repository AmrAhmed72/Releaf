class Plant {
  final int id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final int categoryId;
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

  Plant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.categoryId,
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
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      categoryId: json['categoryId'] ?? 0,
      season: json['season']?.toString() ?? 'Unknown',
      soil: json['soil']?.toString() ?? 'Unknown',
      sunlight: json['sunlight']?.toString() ?? 'Unknown',
      temperature: json['temperature']?.toString() ?? 'Unknown',
      hardinessZones: json['hardinessZones']?.toString() ?? 'Unknown',
      soil_ph: json['soil_ph']?.toString() ?? 'Unknown',
      soil_type: json['soil_type']?.toString() ?? 'Unknown',
      day_sowing: json['day_sowing']?.toString() ?? 'Unknown',
      day_sprout: json['day_sprout']?.toString() ?? 'Unknown',
      day_vegetative: json['day_vegetative']?.toString() ?? 'Unknown',
    );
  }
}