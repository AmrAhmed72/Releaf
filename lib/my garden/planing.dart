import 'package:flutter/material.dart';

import 'reminder.dart';

class PlanningScreen extends StatelessWidget {
  const PlanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image same as MyGarden and RemindersScreen
          Image.asset(
            "assets/Rectangle 52.png",
            fit: BoxFit.cover,
          ),
          // Draggable sheet
          DraggableScrollableSheet(
            initialChildSize: 0.7, // Start at 70% of the screen height
            minChildSize: 0.1, // Minimum size when collapsed
            maxChildSize: 1.0, // Maximum size when fully expanded
            builder: (context, controller) => ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                color: const Color(0xfff4f5ec),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Navigation row
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            "Planning",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff609254),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              // Navigate to MyGarden screen
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Growing",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff392515),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              // Navigate to RemindersScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RemindersScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Reminders",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff392515),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Title

                    const SizedBox(height: 20),
                    // Scrollable content with PlanCards
                    Expanded(
                      child: ListView(
                        controller: controller,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(15.0), // Uniform 15px padding on all sides
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Floating action button

    );
  }
}

// Updated PlanCard widget with shifted icon
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
      height: 130, // Fixed height of 130 pixels
      child: Card(
        elevation: 2,
        color: const Color(0xffeef0e2), // Light green background matching the image
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Matching image padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Plant image
              Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8), // Gap between image and text
              // Plant name and season
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0), // Vertical centering
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
                      const SizedBox(height: 4), // Spacing between text lines
                      Text(
                        'season: $season',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xff22160d),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // More options (vertical dots) and Growing button
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      // Add functionality for more options
                      print("More options pressed for $plantName");
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(0xff392515),
                      size: 20,
                    ),
                    padding: const EdgeInsets.only(left: 60.0), // Shift 15px to the right
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 6), // Vertical spacing
                  OutlinedButton.icon(
                    onPressed: () {
                      // Add functionality for "Growing" button
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