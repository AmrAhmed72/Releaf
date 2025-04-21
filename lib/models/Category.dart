class Category {
  final int id;
  final String name;
  final List<dynamic> plants;
  final String title;
  final String imagePath;

  Category({
    required this.id,
    required this.name,
    required this.plants,
    String? title,
    String? imagePath,
  }) : 
    this.title = title ?? name,
    this.imagePath = imagePath ?? 'assets/categories/${name.toLowerCase()}.jpg';

  factory Category.fromJson(Map<String, dynamic> json) {
    String name = json['name']?.toString() ?? '';
    return Category(
      id: json['id'] ?? 0,
      name: name,
      plants: json['plants'] ?? [],
      title: name,
      imagePath: 'assets/categories/${name.toLowerCase()}.jpg',
    );
  }
}