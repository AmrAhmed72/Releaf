import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/plant.dart';
import '../../../services/Api/api_service.dart';
import '../../../services/Cashe/plant_cache_service.dart';
import '../Plants/PlantDetailScreen.dart';


class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;
  final List<String> recentSearches;
  final Function(String) onSearchSubmitted;
  final VoidCallback onClearRecent;

  const SearchResultsScreen({
    Key? key,
    required this.searchQuery,
    required this.recentSearches,
    required this.onSearchSubmitted,
    required this.onClearRecent,
  }) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final ApiService _apiService = ApiService();
  final PlantCacheService _plantCacheService = PlantCacheService();
  late Future<List<Plant>> _plantsFuture;
  List<Plant> _filteredPlants = [];

  @override
  void initState() {
    super.initState();
    _loadAndFilterPlants();
  }

  Future<void> _loadAndFilterPlants() async {
    try {
      final cachedPlants = await _plantCacheService.getCachedPlants();

      List<Plant> plantsToSearch = [];

      if (cachedPlants != null && cachedPlants.isNotEmpty) {
        plantsToSearch = cachedPlants;
        _filterPlants(plantsToSearch);
      }

      try {
        final freshPlants = await _apiService.getAllPlants();

        if (freshPlants.isNotEmpty) {
          await _plantCacheService.cachePlants(freshPlants);
          plantsToSearch = freshPlants;
          if (mounted) {
            _filterPlants(plantsToSearch);
          }
        }
      } catch (e) {
        print('Error fetching fresh plants: $e');
      }
    } catch (e) {
      print('Error loading plants for search: $e');
      setState(() {
        _filteredPlants = [];
      });
    }
  }

  void _filterPlants(List<Plant> plants) {
    final query = widget.searchQuery.toLowerCase();
    setState(() {
      _filteredPlants = plants.where((plant) {
        return plant.name.toLowerCase().contains(query) ||
            plant.description.toLowerCase().contains(query) ||
            plant.season.toLowerCase().contains(query) ||
            plant.soil.toLowerCase().contains(query) ||
            plant.sunlight.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF0E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF609254),
        elevation: 0,
        title: Text(
          'Search: "${widget.searchQuery}"',
          style: const TextStyle(
            color: Color(0xFFF4F5EC),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF4F5EC)),
          onPressed: () {
            // Return the updated recent searches list when popping back
            Navigator.pop(context, widget.recentSearches);
          },
        ),
        centerTitle: true,
      ),
      body: _filteredPlants.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No plants found for "${widget.searchQuery}"',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredPlants.length,
        itemBuilder: (context, index) {
          final plant = _filteredPlants[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), //0xFFF4F5EC
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlantDetailScreen(plant: plant),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFEEF0E2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: plant.imageUrls.isNotEmpty
                            ? CachedNetworkImage(
                          imageUrl: plant.imageUrls.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF609254),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.image_not_supported,
                            color: Color(0xFF609254),
                          ),
                        )
                            : const Icon(
                          Icons.image_not_supported,
                          color: Color(0xFF609254),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF609254),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plant.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.wb_sunny, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 2),
                              Text(
                                'Season: ${plant.season}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}