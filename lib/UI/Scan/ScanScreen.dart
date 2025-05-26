import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import '../../Widgets/ScanningAnimation.dart';
import '../../services/IdentifyApi.dart';
import 'ResultScreen.dart';
import 'snap_tips_dialog.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription>? _cameras;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnapTipsDialog(context, onContinue: () {});
    });
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    try {
      await _initializeControllerFuture;
      final directory = await getTemporaryDirectory();
      final imagePath = path.join(
        directory.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      final XFile imageFile = await _controller!.takePicture();
      await imageFile.saveTo(imagePath);
      setState(() {
        _imagePath = imagePath;
      });
    } catch (e) {
      print("Error capturing photo: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error capturing photo: $e")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    print("Photos button tapped");
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
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

  Future<void> _identifyPlant() async {
    if (_imagePath == null) {
      return;
    }
    print("Identifying image: $_imagePath");
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor:Color(0xFFF4F5EC), // Solid black barrier
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 300,
          height: 400,
          child: ScanningAnimation(imagePath: _imagePath!),
        ),
      ),
    );

    try {
      var result = await IdentifyApi.identifyFlower(_imagePath!);
      var flowerInfoPrimary = result['primary'];
      var flowerInfoSecondary = result['secondary'];
      print("Primary identification: $flowerInfoPrimary");
      print("Secondary identification: $flowerInfoSecondary");
      Navigator.pop(context); // Close the scanning dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            flowerInfoPrimary: flowerInfoPrimary,
            flowerInfoSecondary: flowerInfoSecondary,
            imagePath: _imagePath!,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close the scanning dialog
      print("Error identifying flower: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error identifying flower: $e")),
      );
    }
  }

  Future<void> _diagnosePlant() async {
    if (_imagePath == null) {
      print("No image selected for diagnosis");
      return;
    }
    print("Diagnosing image: $_imagePath");
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black, // Solid black barrier
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: 300,
          height: 400,
          child: ScanningAnimation(imagePath: _imagePath!),
        ),
      ),
    );
    try {
      var result = await IdentifyApi.predictDisease(_imagePath!);
      print("Disease API response: $result");
      var diseaseName = result['primary'];
      var diseaseDescription = result['secondary'];
      print("Disease: $diseaseName");
      print("Description: $diseaseDescription");
      Navigator.pop(context); // Close the scanning dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            flowerInfoPrimary: diseaseName,
            flowerInfoSecondary: diseaseDescription,
            imagePath: _imagePath!,
            isDiagnosis: true,
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close the scanning dialog
      print("Error diagnosing plant: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error diagnosing plant: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            _imagePath == null
                ? FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.previewSize!.height,
                        height: _controller!.value.previewSize!.width,
                        child: CameraPreview(_controller!),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text("Error initializing camera"));
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ));
                }
              },
            )
                : Positioned.fill(
              child: Image.file(
                File(_imagePath!),
                fit: BoxFit.cover,
              ),
            ),
            if (_imagePath == null)
              Center(
                child: CustomDashedBorder(
                  width: 200,
                  height: 200,
                  strokeWidth: 5,
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
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            if (_imagePath != null)
              Positioned(
                top: 60,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _imagePath = null;
                    });
                  },
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                color: const Color(0xFF609254),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.photo, color: Colors.white),
                      onPressed: _pickImageFromGallery,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _imagePath != null ? _identifyPlant : null,
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
                          onPressed: _imagePath != null ? _diagnosePlant : null,
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
                    IconButton(
                      icon: const Icon(Icons.help_outline, color: Colors.white),
                      onPressed: () {
                        showSnapTipsDialog(context, onContinue: () {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            if (_imagePath == null)
              Positioned(
                bottom: 100,
                left: MediaQuery.of(context).size.width / 2 - 30,
                child: GestureDetector(
                  onTap: _capturePhoto,
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

    path.moveTo(width - cornerRadius, 0);
    path.arcToPoint(
      Offset(width, cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

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

    path.moveTo(width, height - cornerRadius);
    path.arcToPoint(
      Offset(width - cornerRadius, height),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

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

    path.moveTo(cornerRadius, height);
    path.arcToPoint(
      Offset(0, height - cornerRadius),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

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

    path.moveTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
      clockwise: true,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}