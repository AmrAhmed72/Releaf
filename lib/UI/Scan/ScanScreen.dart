import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'snap_tips_dialog.dart'; // Import the utility file

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  String? _imagePath; // To store the path of the captured or selected image
  final ImagePicker _picker = ImagePicker(); // Initialize the ImagePicker

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    // Show the Snap Tips dialog as soon as the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnapTipsDialog(context, onContinue: () {
        // No navigation needed, just close the dialog
      });
    });
  }

  Future<void> _initializeCamera() async {
    // Get the list of available cameras
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      // Select the rear camera (usually the first one)
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
      );
      // Initialize the controller
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Function to capture and save the photo
  Future<void> _capturePhoto() async {
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Get the temporary directory to save the image
      final directory = await getTemporaryDirectory();
      final imagePath = path.join(
        directory.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Capture the photo and save it to the specified path
      final XFile imageFile = await _controller!.takePicture();
      await imageFile.saveTo(imagePath);

      setState(() {
        _imagePath = imagePath; // Store the path of the captured image
      });
    } catch (e) {
      print("Error capturing photo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error capturing photo: $e")),
      );
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImageFromGallery() async {
    print("Photos button tapped"); // Debug print to confirm button tap

    try {
      // Use ImagePicker to select an image from the gallery
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path; // Store the path of the selected image
        });
      } else {
        print("No image selected");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No image selected")),
        );
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking image: $e")),
      );
    }
  }

  // Function to identify the plant using PlantNet API
  Future<void> _identifyPlant() async {
    if (_imagePath == null) return;

    try {
      // Create a multipart request to send the image to PlantNet
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://my-api.plantnet.org/v2/identify/all?api-key=YOUR_API_KEY'),
      );

      // Add the image file to the request
      request.files.add(await http.MultipartFile.fromPath('images', _imagePath!));

      // Add additional parameters (e.g., organs to identify)
      request.fields['organs'] = 'leaf'; // Example: identifying a leaf

      // Send the request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var result = jsonDecode(responseData);

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the results
        var plantName = result['results'][0]['species']['scientificNameWithoutAuthor'];
        print("Identified plant: $plantName");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Identified plant: $plantName")),
        );
      } else {
        print("Error identifying plant: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error identifying plant")),
        );
      }
    } catch (e) {
      print("Error identifying plant: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error identifying plant: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black to avoid white spaces
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen camera preview or captured/selected image
            _imagePath == null
                ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Ensure the camera preview fills the entire screen
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover, // Scale the preview to cover the entire screen
                      child: SizedBox(
                        width: _controller!.value.previewSize!.height,
                        height: _controller!.value.previewSize!.width,
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error initializing camera"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
                : Positioned.fill(
              child: Image.file(
                File(_imagePath!),
                fit: BoxFit.cover, // Scale the captured/selected image to cover the entire screen
              ),
            ),
            // Dashed focus square with rounded corners (only show when camera preview is active)
            if (_imagePath == null)
              Center(
                child: CustomDashedBorder(
                  width: 200,
                  height: 200,
                  strokeWidth:5,
                  dashLength: 50,
                  dashGap: 80,
                  color: Colors.green,
                  cornerRadius: 10,
                  child: const Center(
                    child: Text(
                      "Align plant in frame",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            // Top bar with close button
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Close the screen
                },
              ),
            ),
            // Retake button (only show when an image is captured or selected)
            if (_imagePath != null)
              Positioned(
                top: 60,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _imagePath = null; // Clear the image to show the camera preview again
                    });
                  },
                ),
              ),
            // Bottom bar with buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                color: const Color(0xFF609254), // Green bottom bar
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Photos button
                    IconButton(
                      icon: const Icon(Icons.photo, color: Colors.white),
                      onPressed: _pickImageFromGallery, // Call the function to pick an image
                    ),
                    // Identify and Diagnose buttons
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _imagePath != null
                              ? () {
                            _identifyPlant(); // Call the plant identification function
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF609254),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Identify"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _imagePath != null
                              ? () {
                            print("Diagnose button tapped with image: $_imagePath");
                            // Add plant diagnosis logic here using _imagePath
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF609254),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Diagnose"),
                        ),
                      ],
                    ),
                    // Snap Tips button
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () {
                        // Show the Snap Tips dialog from within CameraScreen
                        showSnapTipsDialog(context, onContinue: () {
                          // No navigation needed here, just close the dialog
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Camera shutter button (only show when camera preview is active)
            if (_imagePath == null)
              Positioned(
                bottom: 100, // Adjusted to move the shutter button higher
                left: MediaQuery.of(context).size.width / 2 - 30,
                child: GestureDetector(
                  onTap: _capturePhoto, // Call the capture photo function
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Custom widget for dashed border with rounded corners
class CustomDashedBorder extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final Color color;
  final double cornerRadius;
  final Widget? child;

  const CustomDashedBorder({
    super.key,
    required this.width,
    required this.height,
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
    required this.color,
    required this.cornerRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: DashedBorderPainter(
          strokeWidth: strokeWidth,
          dashLength: dashLength,
          dashGap: dashGap,
          color: color,
          cornerRadius: cornerRadius,
        ),
        child: child,
      ),
    );
  }
}

// Custom painter to draw the dashed border with rounded corners
class DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double dashLength;
  final double dashGap;
  final Color color;
  final double cornerRadius;

  DashedBorderPainter({
    required this.strokeWidth,
    required this.dashLength,
    required this.dashGap,
    required this.color,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double width = size.width;
    final double height = size.height;

    // Top-left to top-right
    double x = cornerRadius;
    while (x < width - cornerRadius) {
      if (x + dashLength <= width - cornerRadius) {
        path.moveTo(x, 0);
        path.lineTo(x + dashLength, 0);
      } else {
        path.moveTo(x, 0);
        path.lineTo(width - cornerRadius, 0);
      }
      x += dashLength + dashGap;
    }

    // Top-right corner
    path.moveTo(width - cornerRadius, 0);
    path.arcToPoint(
      Offset(width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Right side
    double y = cornerRadius;
    while (y < height - cornerRadius) {
      if (y + dashLength <= height - cornerRadius) {
        path.moveTo(width, y);
        path.lineTo(width, y + dashLength);
      } else {
        path.moveTo(width, y);
        path.lineTo(width, height - cornerRadius);
      }
      y += dashLength + dashGap;
    }

    // Bottom-right corner
    path.moveTo(width, height - cornerRadius);
    path.arcToPoint(
      Offset(width - cornerRadius, height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Bottom side
    x = width - cornerRadius;
    while (x > cornerRadius) {
      if (x - dashLength >= cornerRadius) {
        path.moveTo(x, height);
        path.lineTo(x - dashLength, height);
      } else {
        path.moveTo(x, height);
        path.lineTo(cornerRadius, height);
      }
      x -= (dashLength + dashGap);
    }

    // Bottom-left corner
    path.moveTo(cornerRadius, height);
    path.arcToPoint(
      Offset(0, height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    // Left side
    y = height - cornerRadius;
    while (y > cornerRadius) {
      if (y - dashLength >= cornerRadius) {
        path.moveTo(0, y);
        path.lineTo(0, y - dashLength);
      } else {
        path.moveTo(0, y);
        path.lineTo(0, cornerRadius);
      }
      y -= (dashLength + dashGap);
    }

    // Top-left corner
    path.moveTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}