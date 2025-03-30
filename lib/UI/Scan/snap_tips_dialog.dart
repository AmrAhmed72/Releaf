import 'package:flutter/material.dart';

void showSnapTipsDialog(BuildContext context, {required VoidCallback onContinue}) {
  // Calculate 70% of the screen height
  final double dialogHeight = MediaQuery.of(context).size.height * 0.7;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFFF5F5DC), // Beige background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        height: dialogHeight, // Set the dialog height to 70% of the screen

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute content evenly
          children: [
            // Title: Snap Tips
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Snap Tips",
                style: TextStyle(
                  fontSize: dialogHeight * 0.06, // 6% of dialog height
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            // Correct snap (at the top)
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200, // Correct snap width
                      height: 200, // Correct snap height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/correct.jpg', // Replace with your correct plant image
                          width: 200, // Match the container size
                          height: 200,
                          fit: BoxFit.cover, // Ensure the image fills the circle
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 40, // Proportional to the 200x200 correct snap
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24, // Proportional to the overlay size
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Row of three incorrect snaps (below the correct snap)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                // Too close (with red X)
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 63, // False snap width
                          height: 63, // False snap height
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/too close.png", // Replace with your too close image
                              width: 63, // Match the container size
                              height: 63,
                              fit: BoxFit.cover, // Ensure the image fills the circle
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 18, // Slightly smaller to be proportional to 63x63
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12, // Proportional to the overlay size
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Fixed spacing for better readability
                    const Text(
                      "Too close",
                      style: TextStyle(
                        fontSize: 17, // Snap name font size
                        fontWeight: FontWeight.w600, // Snap name font weight
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Multi-species (with red X, moved down slightly)
                Padding(
                  padding: const EdgeInsets.only(top: 40), // Move "Multi-species" down by 40 pixels
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 63,
                            height: 63,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/multi-species.jpg', // Replace with your multi-species image
                                width: 63, // Match the container size
                                height: 63,
                                fit: BoxFit.cover, // Ensure the image fills the circle
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 18, // Slightly smaller to be proportional to 63x63
                              height: 18,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 12, // Proportional to the overlay size
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Multi-species",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Too far (with red X)
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 63,
                          height: 63,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/too far image.png", // Replace with your too far image
                              width: 63, // Match the container size
                              height: 63,
                              fit: BoxFit.cover, // Ensure the image fills the circle
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 18, // Slightly smaller to be proportional to 63x63
                            height: 18,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 12, // Proportional to the overlay size
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Too far",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Continue button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  onContinue(); // Call the callback to navigate to CameraScreen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF609254), // Green background
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: dialogHeight * 0.1, // 10% of dialog height
                    vertical: dialogHeight * 0.03, // 3% of dialog height
                  ),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: dialogHeight * 0.05, // 5% of dialog height
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}