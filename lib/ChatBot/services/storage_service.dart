import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat.dart';

class StorageService {
  static const String CHATS_KEY = 'chats';
  static const String LAST_CHAT_ID_KEY = 'lastChatId';
  
  // Save chats to local storage
  static Future<void> saveChats(List<Chat> chats, String currentChatId) async {
    final prefs = await SharedPreferences.getInstance();
    final chatData = chats.map((chat) => jsonEncode(chat.toJson())).toList();
    await prefs.setStringList(CHATS_KEY, chatData);
    await prefs.setString(LAST_CHAT_ID_KEY, currentChatId);
  }
  
  // Load chats from local storage
  static Future<Map<String, dynamic>> loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final chatData = prefs.getStringList(CHATS_KEY) ?? [];
    final lastChatId = prefs.getString(LAST_CHAT_ID_KEY);
    
    if (chatData.isEmpty) {
      return {
        'chats': <Chat>[],
        'lastChatId': null,
      };
    }
    
    final chats = chatData
        .map((data) => Chat.fromJson(jsonDecode(data)))
        .toList();
        
    return {
      'chats': chats,
      'lastChatId': lastChatId ?? chats.first.id,
    };
  }
} 