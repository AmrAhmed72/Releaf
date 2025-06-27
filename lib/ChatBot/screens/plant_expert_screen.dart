import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/plant_api_service.dart';
import '../services/storage_service.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/loaders/rotating_logo_loader.dart';

class PlantExpertScreen extends StatefulWidget {
  @override
  _PlantExpertScreenState createState() => _PlantExpertScreenState();
}

class _PlantExpertScreenState extends State<PlantExpertScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _menuIcon = false;
  List<Message> _messages = [];
  List<Chat> _chats = [];
  String _currentChatId = '';

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  // Load chats from local storage
  Future<void> _loadChats() async {
    final data = await StorageService.loadChats();

    if ((data['chats'] as List<Chat>).isEmpty) {
      // Create a first chat if no chats exist
      _createNewChat();
    } else {
      setState(() {
        _chats = data['chats'] as List<Chat>;
        _setCurrentChat(data['lastChatId'] as String);
      });
    }
  }

  // Create a new chat
  void _createNewChat() {
    final newChat = Chat(
      id: const Uuid().v4(),
      title: 'New Chat ${_chats.length + 1}',
      messages: [],
      createdAt: DateTime.now(),
    );

    setState(() {
      _chats.add(newChat);
      _setCurrentChat(newChat.id);
    });

    StorageService.saveChats(_chats, _currentChatId);
  }

  // Set current active chat
  void _setCurrentChat(String chatId) {
    final chat = _chats.firstWhere((c) => c.id == chatId);
    setState(() {
      _currentChatId = chatId;
      _messages = chat.messages;
    });
  }

  // Delete chat
  void _deleteChat(String chatId) {
    // Don't delete if it's the only chat
    if (_chats.length <= 1) {
      return;
    }

    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      setState(() {
        _chats.removeAt(chatIndex);

        // If we deleted the current chat, switch to the first available chat
        if (chatId == _currentChatId && _chats.isNotEmpty) {
          _setCurrentChat(_chats.first.id);
        }
      });

      // Update storage
      StorageService.saveChats(_chats, _currentChatId);
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add(Message(content: userMessage, isUser: true));
      _isLoading = true;
      _controller.clear();
    });

    // Update chat in the list
    final chatIndex = _chats.indexWhere((c) => c.id == _currentChatId);
    if (chatIndex != -1) {
      _chats[chatIndex].messages = _messages;
      // Update chat title based on first message if it's the first user message
      if (_chats[chatIndex].messages.where((m) => m.isUser).length == 1) {
        _chats[chatIndex].title =
            userMessage.length > 20
                ? '${userMessage.substring(0, 20)}...'
                : userMessage;
      }
      StorageService.saveChats(_chats, _currentChatId);
    }

    // Show a snackbar with loading animation while waiting for response
    // -------------
    // context.showLoaderSnackbar(
    //   logoAssetPath: 'assets/images/logo.png',
    //   message: 'Generating plant advice...',
    //   backgroundColor: AppColors.primary,
    // );

    final response = await PlantApiService.generateContent(userMessage);

    // Dismiss the loading snackbar    -----------------------
    // context.hideLoaderSnackbar();

    setState(() {
      _messages.add(Message(content: response, isUser: false));
      _isLoading = false;

      // Update chat with new messages
      final chatIndex = _chats.indexWhere((c) => c.id == _currentChatId);
      if (chatIndex != -1) {
        _chats[chatIndex].messages = _messages;
        StorageService.saveChats(_chats, _currentChatId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Base width for the text field (940) scaled proportionally
    final textFieldWidth = screenWidth * 0.75; // 80% of screen width
    // Original text field width is 940, button width is 74, so button width is 74/940 of text field
    final buttonWidth = textFieldWidth * (110 / 540);
    // Height scaled based on screen height (originally 54)
    final containerHeight =
        screenHeight * 0.07; // 8% of screen height for better visibility
    // Padding scaled proportionally: original left: 20, right: 656
    final leftPadding = textFieldWidth * (20 / 940);
    final rightPadding = textFieldWidth * (656 / 940);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            setState(() {
              _menuIcon = !_menuIcon;
            });
          },
        ),
        title: Text(AppStrings.appTitle, style: TextStyle(color: Colors
            .white,fontFamily: 'Plus Jakarta Sans') ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background content (chat and input)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.background,
                    padding: EdgeInsets.all(16),
                    child:
                        _messages.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/Releaf.png',
                                    width: 200,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Ask me about any plant!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.secondary.withOpacity(
                                        0.6,
                                      ),
                                      fontFamily: 'Plus Jakarta Sans',
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount:
                                  _messages.length + (_isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _messages.length) {
                                  // Show loading indicator as the last item when loading
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: RotatingLogoLoader(
                                        logoAssetPath: 'assets/logo.png',
                                        size: 50,
                                      ),
                                    ),
                                  );
                                }

                                final message = _messages[index];
                                return ChatBubble(
                                  message: message.content,
                                  isUser: message.isUser,
                                );
                              },
                            ),
                  ),
                ),
                SizedBox(height: 16),
                TextSelectionTheme(
                  data: const TextSelectionThemeData(
                    cursorColor: AppColors.secondary,
                    selectionColor: AppColors.secondary,
                    selectionHandleColor: AppColors.secondary,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: containerHeight,
                          padding: EdgeInsets.only(
                            left: leftPadding,
                            right: 20,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: AppColors.textField,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppColors.textFieldBorder,
                              ),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: AppStrings.inputHint,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 15.0,
                              ),
                              hintStyle: TextStyle(
                                color: AppColors.secondary.withOpacity(0.6),
                                fontSize: 16,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                              suffixIcon:
                                  _controller.text.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: AppColors.secondary
                                              .withOpacity(0.6),
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _controller.clear();
                                          });
                                        },
                                      )
                                      : null,
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Plus Jakarta Sans',
                              color: AppColors.secondary,
                            ),
                            cursorColor: AppColors.secondary,

                            maxLines: 1,
                            onSubmitted: (_) => _sendMessage(),
                            onChanged: (text) {
                              // Rebuild to show/hide the clear button
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 48, // Fixed size for circular button
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendMessage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            shape: CircleBorder(),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            disabledBackgroundColor: AppColors.secondary
                                .withOpacity(0.7),
                          ),
                          child:
                              _isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Left sidebar (shown/hidden based on menu icon)
          Visibility(
            visible: _menuIcon,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _menuIcon = false;
                });
              },
              child: Container(
                color: Colors.black26,
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      color: AppColors.primary,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              _createNewChat();
                              setState(() {
                                _menuIcon = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.black),
                                // Plus icon
                                // spacing between icon and text
                                Text(
                                  AppStrings.newChatButton,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _chats.length,
                              itemBuilder: (context, index) {
                                final chat = _chats[index];
                                return InkWell(
                                  onTap: () {
                                    _setCurrentChat(chat.id);
                                    setState(() {
                                      _menuIcon = false;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          _currentChatId == chat.id
                                              ? AppColors.accent.withOpacity(
                                                0.4,
                                              )
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                                  _currentChatId == chat.id
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // Only show delete button if we have more than one chat
                                        if (_chats.length > 1)
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white.withOpacity(
                                                0.7,
                                              ),
                                              size: 18,
                                            ),
                                            onPressed:
                                                () => _deleteChat(chat.id),
                                            tooltip: 'Delete chat',
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                            splashRadius: 20,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              AppStrings.upgradeButton,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
