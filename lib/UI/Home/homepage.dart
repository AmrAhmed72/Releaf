import 'package:releaf/UI/Profile/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:releaf/UI/my garden/garden.dart';
import 'package:releaf/UI/Profile/CommunityScreen.dart';
// Ensure this import is present

// Import models
import '../../models/category.dart';
import '../../models/GrowItem.dart';
import '../../models/CommunityEvent.dart';

// Import data
import '../../data/categories.dart';
import '../../data/GrowItems.dart';
import '../../data/CommunityEvents.dart';
import '../Scan/ScanScreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _index = 0; // Start at the Home tab (index 0)

  // List of screens to navigate to
  final List<Widget> _screens = [
    const HomeContent(), // Home content (index 0)
    const Placeholder(), // Locations screen (index 1, temporary placeholder)
    const Placeholder(), // Camera screen (index 2, will be handled separately)
    MyGarden(), // Favorites screen (index 3)
    ProfileScreen(), // Profile screen (index 4)
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30, color: Color(0xff22160d)), // Index 0: Home
      const Icon(Icons.location_on, size: 30, color: Color(0xff22160d)), // Index 1: Locations
      const Icon(Icons.camera_alt, size: 30, color: Color(0xff22160d)), // Index 2: Camera
      Image.asset(
        'assets/gardenIcon.png',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
      ), // Index 3: Favorites
      const Icon(Icons.person, size: 30, color: Color(0xff22160d)), // Index 4: Profile
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      body: _screens[_index], // Display the selected screen based on the index
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color(0xFF609254),
        backgroundColor: Colors.transparent,
        height: 65,
        index: _index,
        items: items,
        onTap: (index) {
          if (index == 2) {
            // When the camera tab is tapped, navigate to CameraScreen without the navigation bar
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            ).then((_) {
              // After returning from CameraScreen, reset the index to 0 (Home)
              setState(() {
                _index = 0;
              });
            });
          } else {
            // For other tabs, update the index as usual
            setState(() {
              _index = index;
            });
          }
        },
      ),
    );
  }
}

// Separate widget for the Home content
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              _buildTodaysCare(),
              const SizedBox(height: 16),
              _buildMapBanner(),
              const SizedBox(height: 16),
              _buildCategoryList(),
              const SizedBox(height: 16),
              _buildWhatToGrowSection(),
              const SizedBox(height: 16),
              _buildCommunitySection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF609254)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/img_1.png',
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 5),
            const Expanded(
              child: TextField(
                cursorColor: Color(0xFF609254),
                style: TextStyle(
                  color: Color(0xFF392515),
                  fontSize: 11,
                  fontFamily: 'Inter',
                ),
                decoration: InputDecoration(
                  hintText: 'Search plants...',
                  hintStyle: TextStyle(
                    color: Color(0xFF9F8571),
                    fontSize: 11,
                    fontFamily: 'Inter',
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 3),
                  isCollapsed: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysCare() {
    return Card(
      color: const Color(0xFFEEF0E2),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/img.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Water',
                  style: TextStyle(
                    color: Color(0xFF39AD4E),
                    fontSize: 14,
                    fontFamily: 'Laila',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Radish!',
              style: TextStyle(
                color: Color(0xFF392515),
                fontSize: 14,
                fontFamily: 'Laila',
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              'Radish is to be watered at 8 am',
              style: TextStyle(
                color: Color(0xFF4C2B12),
                fontSize: 10,
                fontFamily: 'Laila',
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("View all", style: TextStyle(color: Colors.green)),
                Checkbox(
                  value: _isChecked,
                  onChanged: (val) {
                    setState(() {
                      _isChecked = val ?? false;
                    });
                  },
                  checkColor: Colors.white, // Color of the checkmark
                  activeColor: const Color(0xFF609254), // Color when checked
                  side: const BorderSide(color: Color(0xFF4C2B12)), // Border color when unchecked
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/download.jpg",
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                print("View All Categories tapped");
                // Add navigation to a full categories screen if needed
              },
              child: Row(
                children: [
                  const Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF609254),
                      fontSize: 14,
                      fontFamily: 'Laila',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFF609254),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _categoryCard(category),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(Category category) {
    bool isNetworkImage = category.imagePath.startsWith('http');

    return Container(
      width: 130,
      height: 130,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0xFFEEF0E2),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0xFF9F8571)),
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F4C2B12),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 5,
            top: 20,
            child: Text(
              category.title,
              style: const TextStyle(
                color: Color(0xFF4C2B12),
                fontSize: 16,
                fontFamily: 'Laila',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: 161.81,
              height: 227,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: isNetworkImage
                      ? NetworkImage(category.imagePath)
                      : AssetImage(category.imagePath) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatToGrowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "What to grow in",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: "Summer",
                  items: ["Summer", "Winter", "Spring"].map((month) {
                    return DropdownMenuItem(value: month, child: Text(month));
                  }).toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                print("View All What to Grow tapped");
                // Add navigation to a full "What to grow" screen if needed
              },
              child: Row(
                children: [
                  const Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF609254),
                      fontSize: 14,
                      fontFamily: 'Laila',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFF609254),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 158, // Adjusted height to match the new card design (158)
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: growItems.map((growItem) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _growItem(growItem),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _growItem(GrowItem growItem) {
    return Container(
      width: 165,
      height: 158,
      decoration: ShapeDecoration(
        color: Color(0xFFEEF0E2),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.10, color: Color(0xFF4C2B12)),
          borderRadius: BorderRadius.circular(30),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F4C2B12),
            blurRadius: 2,

            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 165,
              height: 106,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.10, color: Color(0xFF4C2B12)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 163,
                    height: 106,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage(growItem.imagePath), // Use AssetImage for local assets
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.10, color: Color(0xFF4C2B12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 133,
            top: 124,
            child: GestureDetector(
              onTap: () {
                print("${growItem.title} + button tapped");
                // Add functionality for the "+" button (e.g., add to garden)
              },
              child: Container(
                width: 15,
                height: 15,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: ShapeDecoration(
                          color: Color(0xFF609254),
                          shape: OvalBorder(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 3,
                      top: 3,
                      child: Container(
                        width: 9,
                        height: 9,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 3.75,
                              top: -0,
                              child: Container(
                                width: 1.50,
                                height: 9,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFEEF0E2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 9,
                              top: 3.75,
                              child: Transform(
                                transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                                child: Container(
                                  width: 1.50,
                                  height: 9,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFFEEF0E2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 15.50,
            top: 117,
            child: Text(
              growItem.title,
              style: const TextStyle(
                color: Color(0xFF609254),
                fontSize: 18,
                fontFamily: 'Laila',
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Community Section
  Widget _buildCommunitySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Community",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CommunityPage()),
                );
              },
              child: Row(
                children: [
                  const Text(
                    "View All",
                    style: TextStyle(
                      color: Color(0xFF609254),
                      fontSize: 14,
                      fontFamily: 'Laila',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    color: const Color(0xFF609254),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: communityEvents.length,
            itemBuilder: (context, index) {
              final event = communityEvents[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _communityCard(event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _communityCard(CommunityEvent event) {
    return Container(
      width: 251,
      height: 100,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 251,
              height: 100,
              decoration: ShapeDecoration(
                color: Color(0xFFEEF0E2),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0xFF4C2B12)),
                  borderRadius: BorderRadius.circular(15),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F4C2B12),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 12,
            child: SizedBox(
              width: 236,
              child: Text(
                event.title,
                style: const TextStyle(
                  color: Color(0xFFC3824D),
                  fontSize: 14,
                  fontFamily: 'Laila',
                  height: 0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 68,
            child: Text(
              event.date,
              style: const TextStyle(
                color: Color(0xFF4C2B12),
                fontSize: 12,
                fontFamily: 'Laila',
                height: 0,
              ),
            ),
          ),
          Positioned(
            left: 156,
            top: 70,
            child: Text(
              event.link,
              style: const TextStyle(
                color: Color(0xFF609254),
                fontSize: 10,
                fontFamily: 'Laila',
                height: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}