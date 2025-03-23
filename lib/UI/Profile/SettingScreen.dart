import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // Set custom height for the AppBar
        child: AppBar(
          backgroundColor: const Color(0xFF609254), // Green header background
          elevation: 0, // Remove shadow for a cleaner look
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Navigate back to ProfileScreen
            },
          ),
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Membership Section
                _buildSectionTitle('Membership'),
                _buildSettingsItem(
                  icon: Icons.diamond,
                  title: 'My Premium Service',
                  subtitle: 'Membership Status: 500.LE',
                  onTap: () {
                    // Navigate to Premium Service screen
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.refresh,
                  title: 'Restore',
                  onTap: () {
                    // Navigate to Restore screen
                  },
                ),
                const SizedBox(height: 16),

                // General Section
                _buildSectionTitle('General'),
                _buildSettingsItem(
                  icon: Icons.notifications,
                  title: 'Care Notification',
                  onTap: () {
                    // Navigate to Care Notification settings
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.cleaning_services,
                  title: 'Clear Cache',
                  onTap: () {
                    // Clear cache action
                  },
                ),
                const SizedBox(height: 16),

                // Account Section
                _buildSectionTitle('Account'),
                _buildSettingsItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: () {
                    // Log out action
                  },
                ),
                const SizedBox(height: 16),

                // Legal Section
                _buildSectionTitle('Legal'),
                _buildSettingsItem(
                  icon: Icons.security,
                  title: 'Privacy Policy',
                  onTap: () {
                    // Navigate to Privacy Policy screen
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.description,
                  title: 'Terms of Use',
                  onTap: () {
                    // Navigate to Terms of Use screen
                  },
                ),
                const SizedBox(height: 16),

                // About The App Section
                _buildSectionTitle('About The App'),
                _buildSettingsItem(
                  icon: Icons.info,
                  title: 'App Info',
                  onTap: () {
                    // Navigate to App Info screen
                  },
                ),
                _buildSettingsItem(
                  icon: Icons.star,
                  title: 'Encourage Us',
                  onTap: () {
                    // Navigate to Encourage Us screen
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF9F8571),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: ShapeDecoration(
          color: const Color(0xFFEEF0E2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
            Icon(
              icon,
              color: const Color(0xFF39AD4E),
              size: 25,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF392515),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF4C2B12),
                        fontSize: 12,
                        fontFamily: 'Inter',
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9F8571),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}