import 'package:flutter/material.dart';

// Import models and data
import '../../models/CommunityEvent.dart';
import '../../data/CommunityEvents.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // Set custom height for the AppBar
        child: AppBar(
          backgroundColor: const Color(0xFF609254),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Community",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Recent",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: communityEvents.length,
                  itemBuilder: (context, index) {
                    final event = communityEvents[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _communityCard(event),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _communityCard(CommunityEvent event) {
    return Container(
      width: 380,
      height: 282,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEF0E2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Color(0xFFC3824D),
                      fontSize: 16,
                      fontFamily: 'Laila',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.date,
                    style: const TextStyle(
                      color: Color(0xFF4C2B12),
                      fontSize: 14,
                      fontFamily: 'Laila',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Text(
                      event.description,
                      style: const TextStyle(
                        color: Color(0xFF4C2B12),
                        fontSize: 12,
                        fontFamily: 'Laila',
                      ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      print("Visit website tapped for ${event.title}");
                      // Add functionality to open the website (e.g., using url_launcher)
                    },
                    child: Text(
                      event.link,
                      style: const TextStyle(
                        color: Color(0xFF609254),
                        fontSize: 12,
                        fontFamily: 'Laila',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Decorative icons (sun, tree, clouds)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sun icon
                Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 32,
                ),
                const SizedBox(height: 16),
                // Tree icon
                Icon(
                  Icons.park,
                  color: Colors.green,
                  size: 32,
                ),
                const SizedBox(height: 16),
                // Clouds icon (using a stack to create two clouds)
                Stack(
                  children: [
                    Icon(
                      Icons.cloud,
                      color: Colors.grey[400],
                      size: 32,
                    ),
                    Positioned(
                      left: 16,
                      child: Icon(
                        Icons.cloud,
                        color: Colors.grey[400],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}