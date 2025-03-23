import 'package:flutter/material.dart';

// PlanningScreen as a reusable widget (optional)
class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(15.0),
      children: const [
        PlanCard(
          imagePath: 'assets/sweet_basil.png',
          plantName: 'Sweet Basil',
          season: 'summer',
        ),
        SizedBox(height: 16),
        PlanCard(
          imagePath: 'assets/potato.png',
          plantName: 'Potato',
          season: 'summer',
        ),
        SizedBox(height: 16),
        PlanCard(
          imagePath: 'assets/yarrow.png',
          plantName: 'Yarrow',
          season: 'summer',
        ),
      ],
    );
  }
}

// PlanCard widget (unchanged)
class PlanCard extends StatelessWidget {
  final String imagePath;
  final String plantName;
  final String season;

  const PlanCard({
    super.key,
    required this.imagePath,
    required this.plantName,
    required this.season,
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
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80, // Added width and height to match PlantEntry
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
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
                        plantName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4c2b12),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'season: $season',
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
                  IconButton(
                    onPressed: () {
                      print("More options pressed for $plantName");
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xff392515),
                      size: 20,
                    ),
                    padding: const EdgeInsets.only(left: 60.0),
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: () {
                      print("Growing button pressed for $plantName");
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