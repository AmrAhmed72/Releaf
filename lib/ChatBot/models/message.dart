class Message {
  final String content;
  final bool isUser;

  Message({required this.content, required this.isUser});
  
  // Convert message to JSON
  Map<String, dynamic> toJson() => {
    'content': content,
    'isUser': isUser,
  };
  
  // Create message from JSON
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    content: json['content'],
    isUser: json['isUser'],
  );
} 