import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../Widgets/loaders/rotating_logo_loader.dart';
import '../../../models/plant.dart';
import '../../../services/Api/api_service.dart';
import '../../../services/Cashe/plant_cache_service.dart';
import 'PlantDetailScreen.dart';
import 'dart:math';

class AllPlantsScreen extends StatefulWidget {
  const AllPlantsScreen({Key? key}) : super(key: key);

  @override
  State<AllPlantsScreen> createState() => _AllPlantsScreenState();
}

class _AllPlantsScreenState extends State<AllPlantsScreen> {
  final ApiService _apiService = ApiService();
  final PlantCacheService _plantCacheService = PlantCacheService();
  late Future<List<Plant>> _plantsFuture = Future.value([]);

  // Filter state variables
  String _selectedFilterType = 'Season';
  String _selectedSeason = 'All';
  String _selectedSoil = 'All';
  String _selectedSunlight = 'All';

  @override
  void initState() {
    super.initState();
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    final cachedPlants = await _plantCacheService.getCachedPlants();

    if (cachedPlants != null) {
      setState(() {
        _plantsFuture = Future.value(cachedPlants);
      });
    }

    try {
      final freshPlants = await _apiService.getAllPlants();
      await _plantCacheService.cachePlants(freshPlants);

      if (mounted) {
        setState(() {
          _plantsFuture = Future.value(freshPlants);
        });
      }
    } catch (e) {
      print('Error fetching fresh plants: $e');
      if (cachedPlants == null) {
        setState(() {
          _plantsFuture = Future.error(
              'No internet connection and no cached data available');
        });
      }
    }
  }

  Future<void> _refreshPlants() async {
    setState(() {
      _loadPlants();
    });
  }

  List<Plant> _filterPlants(List<Plant> plants) {
    List<Plant> filteredPlants;
    if (_selectedSeason != 'All' && _selectedFilterType == 'Season') {
      filteredPlants = plants
          .where((plant) => plant.season
          .toLowerCase()
          .contains(_selectedSeason.toLowerCase()))
          .toList();
    } else if (_selectedSoil != 'All' && _selectedFilterType == 'Soil') {
      filteredPlants = plants
          .where((plant) =>
          plant.soil.toLowerCase().contains(_selectedSoil.toLowerCase()))
          .toList();
    } else if (_selectedSunlight != 'All' &&
        _selectedFilterType == 'Sunlight') {
      filteredPlants = plants
          .where((plant) => plant.sunlight
          .toLowerCase()
          .contains(_selectedSunlight.toLowerCase()))
          .toList();
    } else {
      filteredPlants = plants;
    }
    final random = Random();
    return filteredPlants..shuffle(random);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempSelectedFilterType = _selectedFilterType;
        String tempSelectedSeason = _selectedSeason;
        String tempSelectedSoil = _selectedSoil;
        String tempSelectedSunlight = _selectedSunlight;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFEEF0E2),
              title: const Text(
                'Filter Plants',
                style: TextStyle(
                  fontFamily: 'Laila',
                  color: Color(0xFF392515),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Filter by:  ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Laila',
                            color: Color(0xff392515),
                          ),
                        ),
                        DropdownButton<String>(
                          value: tempSelectedFilterType,
                          items: ['Season', 'Soil', 'Sunlight'].map((filterType) {
                            return DropdownMenuItem(
                              value: filterType,
                              child: Text(
                                filterType,
                                style: const TextStyle(
                                  fontFamily: 'Laila',
                                  color: Color(0xFF392515),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() {
                                tempSelectedFilterType = value;
                                tempSelectedSeason = 'All';
                                tempSelectedSoil = 'All';
                                tempSelectedSunlight = 'All';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (tempSelectedFilterType == 'Season') ...[
                      const Text(
                        'Season:',
                        style: TextStyle(
                          fontFamily: 'Laila',
                          color: Color(0xFF392515),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...['All', 'Summer', 'Winter', 'Spring', 'All Year'].map((season) {
                        return RadioListTile<String>(
                          title: Text(
                            season,
                            style: const TextStyle(
                              fontFamily: 'Laila',
                              color: Color(0xFF392515),
                            ),
                          ),
                          value: season,
                          groupValue: tempSelectedSeason,
                          activeColor: const Color(0xFF609254),
                          onChanged: (value) {
                            setDialogState(() {
                              tempSelectedSeason = value!;
                            });
                          },
                        );
                      }).toList(),
                    ],
                    if (tempSelectedFilterType == 'Soil') ...[
                      const Text(
                        'Soil Type:',
                        style: TextStyle(
                          fontFamily: 'Laila',
                          color: Color(0xFF392515),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...['All', 'Loamy', 'Sandy', 'Well-drained', 'Moist'].map((soil) {
                        return RadioListTile<String>(
                          title: Text(
                            soil,
                            style: const TextStyle(
                              fontFamily: 'Laila',
                              color: Color(0xFF392515),
                            ),
                          ),
                          value: soil,
                          groupValue: tempSelectedSoil,
                          activeColor: const Color(0xFF609254),
                          onChanged: (value) {
                            setDialogState(() {
                              tempSelectedSoil = value!;
                            });
                          },
                        );
                      }).toList(),
                    ],
                    if (tempSelectedFilterType == 'Sunlight') ...[
                      const Text(
                        'Sunlight:',
                        style: TextStyle(
                          fontFamily: 'Laila',
                          color: Color(0xFF392515),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...['All', 'Full Sun', 'Partial Sun'].map((sunlight) {
                        return RadioListTile<String>(
                          title: Text(
                            sunlight,
                            style: const TextStyle(
                              fontFamily: 'Laila',
                              color: Color(0xFF392515),
                            ),
                          ),
                          value: sunlight,
                          groupValue: tempSelectedSunlight,
                          activeColor: const Color(0xFF609254),
                          onChanged: (value) {
                            setDialogState(() {
                              tempSelectedSunlight = value!;
                            });
                          },
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilterType = tempSelectedFilterType;
                      _selectedSeason = tempSelectedSeason;
                      _selectedSoil = tempSelectedSoil;
                      _selectedSunlight = tempSelectedSunlight;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF609254),
                    foregroundColor: const Color(0xFFF4F5EC),
                  ),
                  child: const Text('Apply Filter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Color(0xFF609254),
      backgroundColor: Color(0xFFF4F5EC),
      onRefresh: _refreshPlants,
      child: Scaffold(
        backgroundColor: Color(0xFFEEF0E2),
        appBar: AppBar(
          backgroundColor: const Color(0xFF609254),
          elevation: 0,
          title: const Text(
            'All Plants',
            style: TextStyle(
              color: Color(0xFFF4F5EC),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF4F5EC)),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Color(0xFFF4F5EC),
                    size: 30,
                  ),
                  onPressed: _showFilterDialog,
                ),
                if (_selectedSeason != 'All' ||
                    _selectedSoil != 'All' ||
                    _selectedSunlight != 'All')
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedSeason != 'All' ||
                _selectedSoil != 'All' ||
                _selectedSunlight != 'All')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: const Color(0xFF609254).withOpacity(0.1),
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_list,
                      size: 16,
                      color: Color(0xFF609254),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Filtered by: ${_selectedFilterType == 'Season' ? _selectedSeason : _selectedFilterType == 'Soil' ? _selectedSoil : _selectedSunlight}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF609254),
                        fontFamily: 'Laila',
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSeason = 'All';
                          _selectedSoil = 'All';
                          _selectedSunlight = 'All';
                        });
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF609254),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
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
                          fontFamily: 'Laila',
                        ),
                      ),
                    );
                  }

                  final filteredPlants = _filterPlants(snapshot.data!);

                  if (filteredPlants.isEmpty &&
                      (_selectedSeason != 'All' ||
                          _selectedSoil != 'All' ||
                          _selectedSunlight != 'All')) {
                    return const Center(
                      child: Text(
                        'No plants available for this filter.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Laila',
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.55, // Adjusted to reflect reduced height
                    ),
                    itemCount: filteredPlants.length,
                    itemBuilder: (context, index) {
                      final plant = filteredPlants[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F5EC),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlantDetailScreen(plant: plant),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      height: 107, // Reduced from 120 to 107 (13 pixels less)
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF609254).withOpacity(0.2),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: plant.imageUrls.isNotEmpty
                                            ? CachedNetworkImage(
                                          imageUrl: plant.imageUrls.first,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                          const Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xFF609254),
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: const Color(0xFFEEF0E2),
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: Color(0xFF609254),
                                                  size: 40,
                                                ),
                                              ),
                                        )
                                            : Container(
                                          color: const Color(0xFFEEF0E2),
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Color(0xFF609254),
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    plant.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF392515),
                                      fontFamily: 'Laila',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    plant.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                      fontFamily: 'Laila',
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    children: [
                                      _buildAttributeChip(
                                        icon: Icons.wb_sunny,
                                        label: plant.sunlight,
                                      ),
                                      _buildAttributeChip(
                                        icon: Icons.calendar_today,
                                        label: plant.season,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributeChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF609254).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF609254).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: const Color(0xFF609254),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xFF609254),
              fontFamily: 'Laila',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}