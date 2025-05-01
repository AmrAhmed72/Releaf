class Country {
  final String name;

  Country({required this.name});

  factory Country.fromJson(Map<String, dynamic> json) => Country(name: json['country']);
}