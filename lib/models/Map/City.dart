class City {
  final String name;
  final String state;
  final String country;

  City({required this.name, required this.state, required this.country});

  factory City.fromJson(Map<String, dynamic> json, String country, String state) {
    return City(name: json['city'], state: state, country: country);
  }
}