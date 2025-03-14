import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> initialDetails;

  const EditProfileScreen({super.key, required this.initialDetails});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _quoteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDetails['name']);
    _usernameController = TextEditingController(text: widget.initialDetails['username']);
    _quoteController = TextEditingController(text: widget.initialDetails['quote']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF609254),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontFamily: 'Inter'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _quoteController,
              decoration: const InputDecoration(labelText: 'Quote'),
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
                };
                Navigator.pop(context, updatedDetails);
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}