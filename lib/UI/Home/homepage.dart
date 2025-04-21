import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:releaf/UI/Profile/ProfileScreen.dart';
import 'package:releaf/UI/my garden/garden.dart';
import 'package:releaf/UI/Profile/CommunityScreen.dart';
import 'package:releaf/UI/Scan/ScanScreen.dart';
import 'package:releaf/UI/map/MapScreen.dart';
import 'package:releaf/screens/categories_screen.dart';
import 'package:releaf/UI/Home/PlantDetailScreen.dart';
import 'package:releaf/screens/category_detail_screen.dart';
import 'package:releaf/screens/all_plants_screen.dart';



// Import models
import 'package:releaf/models/category.dart';
import 'package:releaf/models/GrowItem.dart';
import 'package:releaf/models/CommunityEvent.dart';
import 'package:releaf/models/plant.dart';

// Import data
import 'package:releaf/data/categories.dart';
import 'package:releaf/data/GrowItems.dart';
import 'package:releaf/data/CommunityEvents.dart';
import 'package:releaf/services/api_service.dart';

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
    const MapScreen(), // Locations screen (index 1)
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
            // When the camera tab is tapped, navigate to CameraScreen
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
  final ApiService _apiService = ApiService();
  late Future<List<Plant>> _plantsFuture;
  String _selectedFilterType = 'Season'; // Track filter type (Season, Soil, Sunlight)
  String _selectedSeason = 'Summer';
  String _selectedSoil = 'Loamy';
  String _selectedSunlight = 'Full Sun';

  @override
  void initState() {
    super.initState();
    _plantsFuture = _apiService.getAllPlants();
  }

  List<Plant> _filterPlants(List<Plant> plants) {
    return plants.where((plant) {
      if (_selectedFilterType == 'Season') {
        // Handle complex season values (e.g., "Spring to Summer" includes "Spring" or "Summer")
        return plant.season.toLowerCase().contains(_selectedSeason.toLowerCase());
      } else if (_selectedFilterType == 'Soil') {
        return plant.soil.toLowerCase().contains(_selectedSoil.toLowerCase());
      } else if (_selectedFilterType == 'Sunlight') {
        return plant.sunlight.toLowerCase().contains(_selectedSunlight.toLowerCase());
      }
      return true; // Default: no filter
    }).toList();
  }

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
                  checkColor: Colors.white,
                  activeColor: const Color(0xFF609254),
                  side: const BorderSide(color: Color(0xFF4C2B12)),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: Container(
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
                    image: AssetImage(category.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                // Filter Type Dropdown
                DropdownButton<String>(
                  value: _selectedFilterType,
                  items: ['Season', 'Soil', 'Sunlight'].map((filterType) {
                    return DropdownMenuItem(
                      value: filterType,
                      child: Text(filterType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedFilterType = value;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                // Dynamic Filter Value Dropdown
                if (_selectedFilterType == 'Season')
                  DropdownButton<String>(
                    value: _selectedSeason,
                    items: ['Summer', 'Winter', 'Spring', 'All Year'].map((season) {
                      return DropdownMenuItem(
                        value: season,
                        child: Text(season),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSeason = value;
                        });
                      }
                    },
                  ),
                if (_selectedFilterType == 'Soil')
                  DropdownButton<String>(
                    value: _selectedSoil,
                    items: ['Loamy', 'Sandy', 'Well-drained', 'Moist'].map((soil) {
                      return DropdownMenuItem(
                        value: soil,
                        child: Text(soil),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSoil = value;
                        });
                      }
                    },
                  ),
                if (_selectedFilterType == 'Sunlight')
                  DropdownButton<String>(
                    value: _selectedSunlight,
                    items: ['Full Sun', 'Partial Sun'].map((sunlight) {
                      return DropdownMenuItem(
                        value: sunlight,
                        child: Text(sunlight),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSunlight = value;
                        });
                      }
                    },
                  ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllPlantsScreen(),
                  ),
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
        const SizedBox(height: 8),
        SizedBox(
          height: 158,
          child: FutureBuilder<List<Plant>>(
            future: _plantsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF609254),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No plants found.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              // Apply filter
              final filteredPlants = _filterPlants(snapshot.data!);
              print('Filtered plants: ${filteredPlants.length}'); // Debug log

              if (filteredPlants.isEmpty) {
                return const Center(
                  child: Text(
                    'No plants available for this filter.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredPlants.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _growItem(filteredPlants[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _growItem(Plant plant) {
    return GestureDetector(
      onTap: () {
        // Navigate to PlantDetailScreen when the plant is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: plant),
          ),
        );
      },
      child: Container(
        width: 165,
        height: 158,
        decoration: ShapeDecoration(
          color: const Color(0xFFEEF0E2),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.10, color: Color(0xFF4C2B12)),
            borderRadius: BorderRadius.circular(30),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F4C2B12),
              blurRadius: 4,
              offset: Offset(0, 4),
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
                    side: const BorderSide(width: 0.10, color: Color(0xFF4C2B12)),
                    borderRadius: const BorderRadius.only(
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
                          image: plant.imageUrls.isNotEmpty
                              ? CachedNetworkImageProvider(plant.imageUrls.first)
                              : const AssetImage('assets/placeholder_plant.png') as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.10, color: Color(0xFF4C2B12)),
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
                  // Add functionality for the "+" button
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
                          decoration: const ShapeDecoration(
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
                                top: 0,
                                child: Container(
                                  width: 1.50,
                                  height: 9,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFEEF0E2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 9,
                                top: 3.75,
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..translate(0.0, 0.0)
                                    ..rotateZ(1.57),
                                  child: Container(
                                    width: 1.50,
                                    height: 9,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFEEF0E2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
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
                plant.name,
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
      ),
    );
  }

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