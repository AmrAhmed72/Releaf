import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, String?> initialDetails;

  const EditProfileScreen({super.key, required this.initialDetails});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _quoteController;
  File? _profileImage; // Store selected profile image
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDetails['name']);
    _usernameController = TextEditingController(text: widget.initialDetails['username']);
    _quoteController = TextEditingController(text: widget.initialDetails['quote']);
    // Initialize _profileImage from initialDetails if available and valid
    if (widget.initialDetails['profileImage'] != null) {
      final file = File(widget.initialDetails['profileImage']!);
      if (file.existsSync()) {
        _profileImage = file;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  // Function to pick an image and save it to documents directory
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await File(pickedFile.path).copy('${directory.path}/$fileName');

      setState(() {
        _profileImage = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: const TextSelectionThemeData(
        cursorColor: Color(0xFF609254),
        selectionColor: Color(0xFF609254),
        selectionHandleColor: Color(0xFF609254),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5EC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: const Color(0xFF609254),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF4F5EC)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Color(0xFFF4F5EC),
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile photo section
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          color: const Color(0xFFF4F5EC),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x3F4C2B12),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.5),
                          child: Container(
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                              image: DecorationImage(
                                image: _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : const AssetImage('assets/profile.jpg') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Color(0xFF39AD4E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  cursorColor: const Color(0xFF609254),
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF609254)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextField(
                  cursorColor: const Color(0xFF609254),
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF609254)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextField(
                  cursorColor: const Color(0xFF609254),
                  controller: _quoteController,
                  decoration: const InputDecoration(
                    labelText: 'Quote',
                    labelStyle: TextStyle(color: Colors.grey),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF609254)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF609254),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    final updatedDetails = {
                      'name': _nameController.text,
                      'username': _usernameController.text,
                      'quote': _quoteController.text,
                      'profileImage': _profileImage?.path, // Pass image path
                    };
                    Navigator.pop(context, updatedDetails);
                  },
                  child: Center(
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}