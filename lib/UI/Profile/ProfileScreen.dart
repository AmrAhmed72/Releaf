import 'package:flutter/material.dart';
import 'package:releaf/UI/Profile/CommunityScreen.dart';
import 'SettingScreen.dart';
import 'EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, String> userDetails = {
    'name': 'Amr',
    'username': 'Egypt',
    'quote': 'This oak tree and me, we\'re made of the same stuff.',
  };

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF4F5EC),



      body: SafeArea(
        child: Stack(
          children: [
            // Background image at the top
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width, // Full width
                height: 124,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/profileBG.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Main content with ListView
            Positioned.fill(
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  // Profile picture
                  Center(
                    child: Container(
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
                            image: const DecorationImage(
                              image: AssetImage('assets/Rectangle 73.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // User details
                  Center(
                    child: Text(
                      userDetails['name']!,
                      style: const TextStyle(
                        color: Color(0xFF3B812A),
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: Color(0xFF9F8470),
                        ),
                        Text(
                          userDetails['username']!,
                          style: const TextStyle(
                            color: Color(0xFF9F8470),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        '"${userDetails['quote']!}"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF9F8571),
                          fontSize: 10,
                          fontFamily: 'Laila',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Action buttons
                  _buildActionButton(
                    icon: Icons.photo_album,
                    title: 'album',
                    subtitle: 'all your saved memories in one place',
                    onTap: () {
                      // Add navigation or action for album
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.person,
                    title: 'profile',
                    subtitle: 'update your personal details',
                    onTap: () async {
                      final updatedDetails = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            initialDetails: userDetails,
                          ),
                        ),
                      );
                      if (updatedDetails != null) {
                        setState(() {
                          userDetails = updatedDetails;
                        });
                      }
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.settings,
                    title: 'settings',
                    subtitle: 'settings and privacy',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      );
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.group,
                    title: 'community',
                    subtitle: 'connect with other gardeners',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  CommunityPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity, // Full width
          height: 71,
          decoration: ShapeDecoration(
            color: const Color(0xFFEEF0E2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3F4C2B12),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                  icon,
                  color: const Color(0xFF39AD4E),
                  size: 30,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF392515),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF4C2B12),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}