import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/plant.dart';
import 'package:releaf/UI/Home/Plants/PlantDetailScreen.dart'; // Import PlantDetailScreen

class PlantSuggestionScreen extends StatelessWidget {
  final List<Plant> trees;
  final List<Plant> flowers;
  final List<Plant> vegetables;

  const PlantSuggestionScreen({
    super.key,
    required this.trees,
    required this.flowers,
    required this.vegetables,
  });

  Widget _buildPlantList(BuildContext context, List<Plant> plants) {
    if (plants.isEmpty) {
      return const Center(
        child: Text(
          'No plants found in this category.',
          style: TextStyle(
            color: Color(0xFF392515),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        final plant = plants[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
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
                  // Plant Image
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
                  // Plant Details
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
                            const SizedBox(width: 4),
                            Text(
                              'temp: ${plant.temperature}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F5EC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF609254),
          title: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: const Text(
              'Suggested Plants',
              style: TextStyle(
                color: Color(0xFFF4F5EC),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF4F5EC)),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: const Color(0xFFF4F5EC),
            unselectedLabelColor: const Color(0xFFEEF0E2).withOpacity(0.7),
            indicatorColor: const Color(0xFFEEF0E2),
            tabs: const [
              Tab(text: 'Trees'),
              Tab(text: 'Flowers'),
              Tab(text: 'Vegetables'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPlantList(context, trees),
            _buildPlantList(context, flowers),
            _buildPlantList(context, vegetables),
          ],
        ),
      ),
    );
  }
}