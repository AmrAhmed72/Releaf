
class Campaign {
  final int id;
  final String title;
  final String date;
  final String link;
  final String location;
  final String description;
  final bool isStatic; // Flag to identify if this is a static campaign

  Campaign({
    required this.id,
    required this.title,
    required this.date,
    required this.link,
    required this.location,
    required this.description,
    this.isStatic = false, // Default to false for API campaigns
  });

  // Factory constructor for static campaigns
  factory Campaign.static({
    required String title,
    required String date,
    required String link,
    required String description,
  }) {
    return Campaign(
      id: -1, // Negative ID for static campaigns
      title: title,
      date: date,
      link: link,
      location: '', // Empty for static campaigns
      description: description,
      isStatic: true,
    );
  }

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      link: json['link']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'link': link,
      'location': location,
      'description': description,
    };
  }

  // Convert Campaign to CommunityEvent for compatibility with your UI
  
}