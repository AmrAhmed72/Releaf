import 'package:releaf/models/CommunityEvent.dart';
class Campaign {
  final int id;
  final String title;
  final String date;
  final String link;
  final String location;
  final String description;

  Campaign({
    required this.id,
    required this.title,
    required this.date,
    required this.link,
    required this.location,
    required this.description,
  });

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

  // Convert Campaign to CommunityEvent for compatibility with your UI
  CommunityEvent toCommunityEvent() {
    return CommunityEvent(
      title: title,
      date: date,
      link: link,
      description: description,
    );
  }
}