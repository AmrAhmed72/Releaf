import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:releaf/UI/Home/Search/search_screen.dart';
import 'package:releaf/UI/Profile/ProfileScreen.dart';
import 'package:releaf/UI/my garden/garden.dart';
import 'package:releaf/UI/Profile/CommunityScreen.dart';
import 'package:releaf/UI/Scan/ScanScreen.dart';
import 'package:releaf/UI/map/MapScreen.dart';
import 'package:releaf/UI/Home/Category/categories_screen.dart';
import 'package:releaf/UI/Home/Plants/PlantDetailScreen.dart';
import 'package:releaf/UI/Home/Category/category_detail_screen.dart';
import 'package:releaf/UI/Home/Plants/all_plants_screen.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:releaf/models/category.dart';
import 'package:releaf/models/campaign.dart';
import 'package:releaf/models/plant.dart';
import 'package:releaf/data/categories.dart';
import 'package:releaf/services/Api/api_service.dart';
import 'package:releaf/services/Cashe/campaign_cache_service.dart';
import 'package:releaf/services/Cashe/plant_cache_service.dart';
import 'package:releaf/Widgets/loaders/rotating_logo_loader.dart';
import 'package:releaf/UI/my%20garden/grawing/growing_plants_service.dart';
import '../../data/Shared_Prefs/Shared_Prefs.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _index = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeContent(
        onMapBannerTapped: () {
          setState(() {
            _index = 1;
          });
        },
      ),
      const MapScreen(),
      const Placeholder(),
      const MyGarden(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.home, size: 30, color: Color(0xff22160d)),
      const Icon(Icons.location_on, size: 30, color: Color(0xff22160d)),
      const Icon(Icons.camera_alt, size: 30, color: Color(0xff22160d)),
      Image.asset(
        'assets/potted-plant.png',
        height: 29,
        fit: BoxFit.cover,
      ),
      const Icon(Icons.person, size: 30, color: Color(0xff22160d)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EC),
      body: _screens[_index],
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color(0xFF609254),
        backgroundColor: Colors.transparent,
        height: 65,
        index: _index,
        items: items,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraScreen()),
            ).then((_) {
              setState(() {
                _index = 0;
              });
            });
          } else {
            setState(() {
              _index = index;
            });
          }
        },
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onMapBannerTapped;

  const HomeContent({super.key, required this.onMapBannerTapped});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool _isChecked = false;
  final ApiService _apiService = ApiService();
  final CampaignCacheService _campaignCacheService = CampaignCacheService();
  final PlantCacheService _plantCacheService = PlantCacheService();
  Future<List<Plant>> _plantsFuture = Future.value([]);
  Future<List<Campaign>> _campaignsFuture = Future.value([]);
  List<Plant> growingPlants = [];
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadPlants();
    _loadCampaigns();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    final searches = await SharedPrefs.loadRecentSearches();
    setState(() {
      _recentSearches = searches;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadPlants() async {
    try {
      final cachedPlants = await _plantCacheService.getCachedPlants();
      if (cachedPlants != null && cachedPlants.isNotEmpty) {
        setState(() {
          _plantsFuture = Future.value(cachedPlants);
        });
      } else {
        setState(() {
          _plantsFuture = _apiService.getAllPlants();
        });
      }

      try {
        final freshPlants = await _apiService.getAllPlants();
        if (freshPlants.isNotEmpty) {
          await _plantCacheService.cachePlants(freshPlants);
          if (mounted) {
            setState(() {
              _plantsFuture = Future.value(freshPlants);
            });
          }
        }
      } catch (e) {
        print('Error fetching fresh plants: $e');
      }
    } catch (e) {
      print('Error loading plants: $e');
      setState(() {
        _plantsFuture = _apiService.getAllPlants();
      });
    }
  }

  Future<void> _loadCampaigns() async {
    try {
      final cachedCampaigns = await _campaignCacheService.getCachedCampaigns();
      if (cachedCampaigns != null && cachedCampaigns.isNotEmpty) {
        setState(() {
          _campaignsFuture = Future.value(cachedCampaigns);
        });
      } else {
        setState(() {
          _campaignsFuture = _apiService.getAllCampaigns();
        });
      }

      try {
        final freshCampaigns = await _apiService.getAllCampaigns();
        if (freshCampaigns.isNotEmpty) {
          await _campaignCacheService.cacheCampaigns(freshCampaigns);
          if (mounted) {
            setState(() {
              _campaignsFuture = Future.value(freshCampaigns);
            });
          }
        }
      } catch (e) {
        print('Error fetching fresh campaigns: $e');
      }
    } catch (e) {
      print('Error loading campaigns: $e');
      setState(() {
        _campaignsFuture = _apiService.getAllCampaigns();
      });
    }
  }

  Future<void> _refreshHome() async {
    setState(() {
      _plantsFuture = _apiService.getAllPlants().then((freshPlants) async {
        if (freshPlants.isNotEmpty) {
          await _plantCacheService.cachePlants(freshPlants);
        }
        return freshPlants;
      });
      _campaignsFuture = _apiService.getAllCampaigns().then((freshCampaigns) async {
        if (freshCampaigns.isNotEmpty) {
          await _campaignCacheService.cacheCampaigns(freshCampaigns);
        }
        return freshCampaigns;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: RefreshIndicator(
          color: const Color(0xFF609254),
          backgroundColor: const Color(0xFFF4F5EC),
          onRefresh: _refreshHome,
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
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(
              recentSearches: _recentSearches,
              onSearchSubmitted: (query) async {
                setState(() {
                  if (!_recentSearches.contains(query) && query.trim().isNotEmpty) {
                    _recentSearches.insert(0, query);
                    if (_recentSearches.length > 6) _recentSearches.removeLast();
                    SharedPrefs.saveRecentSearches(_recentSearches);
                  }
                });
              },
              onClearRecent: () async {
                setState(() {
                  _recentSearches.clear();
                  SharedPrefs.clearRecentSearches();
                });
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: TextSelectionTheme(
          data: const TextSelectionThemeData(
            cursorColor: Color(0xFF609254),
            selectionColor: Color(0xFF609254),
            selectionHandleColor: Color(0xFF609254),
          ),
          child: Container(
            height: 37,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF609254)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/output-onlinepngtools.png',
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Search plants...',
                      style: TextStyle(
                        color: Color(0xFF9F8571),
                        fontSize: 14,
                        fontFamily: 'Inter',
                      ),
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
    return GestureDetector(
      onTap: widget.onMapBannerTapped,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 180,
          width: double.infinity,
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(31.2357, 30.0444),
                  initialZoom: 5,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
                  child: const Text(
                    'Tap to Explore Map',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
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
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xff392515),
                fontFamily: 'Laila',
              ),
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
            const Text(
              "What to grow",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                fontFamily: 'Laila',
                color: Color(0xff392515),
              ),
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
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RotatingLogoLoader(
                      logoAssetPath: 'assets/logo.png',
                      size: 50,
                    ),
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

              final plants = snapshot.data!.take(10).toList(); // Take first 10 plants

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _growItem(plants[index]),
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlantDetailScreen(plant: plant),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
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
                    GrowingPlantsService().addPlant(plant);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFFEEF0E2),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 162,
                                height: 142,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: const Color(0xffeef0e2),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color(0xffc3824d),
                                        width: 5.2,
                                      ),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Color(0xffc3824d),
                                        size: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Add to Growing',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffc3824d),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    );
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
              "Camapaign",
              style: TextStyle(
                  fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xff392515)),
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
          child: FutureBuilder<List<Campaign>>(
            future: _campaignsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RotatingLogoLoader(
                      logoAssetPath: 'assets/logo.png',
                      size: 50,
                    ),
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
                    'No campaigns available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              final campaigns = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _communityCard(campaign),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _communityCard(Campaign campaign) {
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
                campaign.title,
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
              campaign.date,
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
              campaign.link,
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