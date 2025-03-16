import 'package:releaf/FavScreen.dart';
import 'package:releaf/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:releaf/my%20garden/garden.dart';

class Homepage extends StatefulWidget {
  final List<Map<String, String>> categories = [
    {'title': 'Trees', 'imagePath': 'assets/trees.png'},
    {'title': 'Flowers', 'imagePath': 'assets/flowers.png'},
    {'title': 'Vegetables', 'imagePath': 'assets/vegandfrut.png'},
    {'title': 'Herbs', 'imagePath': 'assets/ferns.png'},
    {'title': 'Ferns', 'imagePath': 'assets/ferns.png'},
  ];

  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _index = 0; // Start at the Home tab (index 0)

  // List of screens to navigate to
  final List<Widget> _screens = [
    const HomeContent(), // Home content (index 0)
    const Placeholder(), // Locations screen (index 1, temporary placeholder)
    const Placeholder(), // Camera screen (index 2, temporary placeholder)
    MyGarden(),  // Favorites screen (index 3)
     ProfileScreen(), // Profile screen (index 4)
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30),        // Index 0: Home
      const Icon(Icons.location_on, size: 30), // Index 1: Locations
      const Icon(Icons.camera_alt, size: 30),  // Index 2: Camera
      const Icon(Icons.favorite, size: 30),    // Index 3: Favorites
      const Icon(Icons.person, size: 30),      // Index 4: Profile
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
          setState(() {
            _index = index; // Update the index when a tab is tapped
          });
        },
      ),
    );
  }
}

// Separate widget for the Home content (previously inside the Scaffold body)
class HomeContent extends StatelessWidget {
  final List<Map<String, String>> categories;

  const HomeContent({super.key, this.categories = const [
    {'title': 'Trees', 'imagePath': 'assets/trees.png'},
    {'title': 'Flowers', 'imagePath': 'assets/flowers.png'},
    {'title': 'Vegetables', 'imagePath': 'assets/vegandfrut.png'},
    {'title': 'Herbs', 'imagePath': 'assets/ferns.png'},
    {'title': 'Ferns', 'imagePath': 'assets/ferns.png'},
  ]});

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
              _buildImageBanner(),
              const SizedBox(height: 16),
              _buildCategoryList(),
              const SizedBox(height: 16),
              _buildWhatToGrowSection(),
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
                Checkbox(value: false, onChanged: (val) {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        "assets/images.jpeg-1.jpg",
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
        const Text(
          "Categories",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _categoryCard(category['title']!, category['imagePath']!),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(String title, String imagePath) {
    bool isNetworkImage = imagePath.startsWith('http');

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
              title,
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
                      ? NetworkImage(imagePath)
                      : AssetImage(imagePath) as ImageProvider,
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
          children: [
            const Text(
              "What to grow in",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: "Nov",
              items: ["Nov", "Dec", "Jan"].map((month) {
                return DropdownMenuItem(value: month, child: Text(month));
              }).toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _growItem("assets/spinach.jpg"),
              _growItem("assets/potatoes.jpg"),
              _growItem("assets/carrots.jpg"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _growItem(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}