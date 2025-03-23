import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  PlantDetailScreen({super.key});

  // Define the plant data as a list (for now, just Garlic)
  final List<Plant> plants = [
    Plant(
      title: 'Garlic',
      headerImage: 'assets/garlic.jpg',
      types: [
        PlantType(name: 'Italian garlic', imageUrl: 'assets/Rectangle 58.png'),
        PlantType(name: 'Solo garlic', imageUrl: 'assets/Rectangle 59.png'),
        PlantType(name: 'Godavari garlic', imageUrl: 'assets/Rectangle 60.png'),
        PlantType(name: 'Shweta garlic', imageUrl: 'assets/Rectangle 61.png'),
        PlantType(name: 'Creole garlic', imageUrl: 'assets/Rectangle 58.png'),
      ],
      tabs: {
        'description': 'A herb growing from a strongly aromatic, rounded bulb composed of around 10 to 20 cloves covered in a papery coat. The long, sword-shaped leaves are attached to an underground stem and the greenish-white or pinkish flowers grow in dense, spherical clusters atop a flower stalk.',
        'suitable_location': 'Well-drained areas with full sun exposure.',
        'soil_preparation': 'Loosen the soil and mix in compost.',
        'growth_timeline': 'Plant in fall, harvest in summer (6-9 months).',
      },
      conditions: Conditions(
        temperature: '20° - 38°',
        sunlight: 'Full sun',
        soil: 'Potting soil mix',
        hardinessZones: '3-11',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // For this single screen, we'll use the first plant (Garlic)
    final plant = plants[0];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(35), // Reduced height for a small AppBar
        child: AppBar(
          backgroundColor: const Color(0xFFF4F5EC),
          elevation: 0, // No shadow for a flat design
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Navigate back to the previous screen
            },
          ),
          title: Text(
            plant.title,
            style: const TextStyle(
              fontSize: 18, // Smaller font size for a compact look
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true, // Center the title
        ),
      ),

      backgroundColor: const Color(0xFFF4F5EC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(plant.headerImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                plant.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Types Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

              ),

            ),
            SizedBox(height: 8),
            SizedBox(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: plant.types.length,
                itemBuilder: (context, index) {
                  final type = plant.types[index];
                  return PlantTypeCard(imageUrl: type.imageUrl, label: type.name);
                },
              ),
            ),
            // Tabs Section with constrained height
            SizedBox(
              height: 200,
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xE2DED0),
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TabBar(
                        isScrollable: true,
                        labelColor: Colors.green,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.green,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        tabAlignment: TabAlignment.start,
                        tabs: const [
                          CustomTab(text: 'Description'),
                          CustomTab(text: 'Suitable location'),
                          CustomTab(text: 'Soil preparation'),
                          CustomTab(text: 'Growth timeline'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              plant.tabs['description'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              plant.tabs['suitable_location'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              plant.tabs['soil_preparation'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              plant.tabs['growth_timeline'] ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Conditions Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Conditions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ConditionRow(
                    icon: Icons.thermostat,
                    label: 'Temperature',
                    value: plant.conditions.temperature,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.wb_sunny,
                    label: 'Sunlight',
                    value: plant.conditions.sunlight,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.spa,
                    label: 'Soil',
                    value: plant.conditions.soil,
                  ),
                  const SizedBox(height: 8.0),
                  ConditionRow(
                    icon: Icons.landscape,
                    label: 'Hardiness Zones',
                    value: plant.conditions.hardinessZones,
                  ),
                ],
              ),
            ),
            // Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Planning to grow button
                  Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Planning to grow 🌱',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Growing it button
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF51B661),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Growing it 🌿',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Tab Widget to ensure full text visibility
class CustomTab extends StatelessWidget {
  final String text;

  const CustomTab({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        overflow: TextOverflow.visible,
        softWrap: false,
      ),
    );
  }
}

// Custom widget for plant types
class PlantTypeCard extends StatelessWidget {
  final String imageUrl;
  final String label;

  const PlantTypeCard({super.key, required this.imageUrl, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

// Custom widget for condition rows
class ConditionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ConditionRow({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 24.0),
              const SizedBox(width: 12.0),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

// Plant model classes
class Plant {
  final String title;
  final String headerImage;
  final List<PlantType> types;
  final Map<String, String> tabs;
  final Conditions conditions;

  Plant({
    required this.title,
    required this.headerImage,
    required this.types,
    required this.tabs,
    required this.conditions,
  });
}

class PlantType {
  final String name;
  final String imageUrl;

  PlantType({required this.name, required this.imageUrl});
}

class Conditions {
  final String temperature;
  final String sunlight;
  final String soil;
  final String hardinessZones;

  Conditions({
    required this.temperature,
    required this.sunlight,
    required this.soil,
    required this.hardinessZones,
  });
}