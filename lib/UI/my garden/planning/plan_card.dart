import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/plant.dart';
import '../grawing/grawing_plants.dart';

class PlanCard extends StatelessWidget {
  final Plant plant; // Changed to Plant object
  final VoidCallback onRemove; // Callback for removing the plant

  const PlanCard({
    super.key,
    required this.plant,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Card(
        elevation: 2,
        color: const Color(0xffeef0e2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: plant.imageUrls.isNotEmpty ? plant.imageUrls.first : '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF609254),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        plant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4c2b12),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'season: ${plant.season ?? 'Unknown'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff22160d),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40), // Shift 5 pixels to the right
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'remove') {
                          onRemove();
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'remove',
                          child: Text('Remove'),
                        ),
                      ],
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Color(0xff392515),
                        size: 20,
                      ),
                      offset: const Offset(0, 20), // Adjust menu position
                    ),
                  ),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Add plant to growingPlants if not already added
                      if (!growingPlants.contains(plant)) {
                        growingPlants.add(plant);
                      }
                      // Show popup dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: const Color(0xFFF4F5EC),
                            title: const Text(
                              'Success',
                              style: TextStyle(
                                color: Color(0xff392515),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              '${plant.name} added to Growing!',
                              style: const TextStyle(
                                color: Color(0xff392515),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close dialog
                                  // Navigate to MyGarden with the plant and Growing tab
                                  Navigator.pushNamed(
                                    context,
                                    '/my_garden',
                                    arguments: {'plant': plant, 'tab': 'Growing'},
                                  );
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Color(0xff609254),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xff609254),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    icon: const Icon(
                      Icons.add,
                      color: Color(0xff609254),
                      size: 16,
                    ),
                    label: const Text(
                      'Growing',
                      style: TextStyle(
                        color: Color(0xff609254),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}