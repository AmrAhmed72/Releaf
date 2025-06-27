import 'message.dart';

class Chat {
  final String id;
  String title;
  List<Message> messages;
  final DateTime createdAt;
  
  Chat({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });
  
  // Convert chat to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'messages': messages.map((m) => m.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };
  
  // Create chat from JSON
  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json['id'],
    title: json['title'],
    messages: (json['messages'] as List)
        .map((m) => Message.fromJson(m as Map<String, dynamic>)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
  );
} 