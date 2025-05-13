import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A widget that displays a rotating logo animation.
/// 
/// This widget creates a rotating animation using the provided image asset path.
/// It can be customized with size, rotation speed, and clockwise direction.
class RotatingLogoLoader extends StatefulWidget {
  /// The asset path to the logo image
  final String logoAssetPath;
  
  /// Size of the logo (width and height)
  final double size;
  
  /// Duration of one complete rotation in seconds
  final int rotationDurationSeconds;
  
  /// Whether to rotate clockwise (true) or counter-clockwise (false)
  final bool clockwise;
  
  /// Optional box fit for the image
  final BoxFit? fit;

  const RotatingLogoLoader({
    Key? key,
    required this.logoAssetPath,
    this.size = 60,
    this.rotationDurationSeconds = 2,
    this.clockwise = true,
    this.fit,
  }) : super(key: key);
  
  @override
  _RotatingLogoLoaderState createState() => _RotatingLogoLoaderState();
}

class _RotatingLogoLoaderState extends State<RotatingLogoLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: widget.rotationDurationSeconds),
      vsync: this,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: (widget.clockwise ? 1 : -1) * _controller.value * 2 * math.pi,
            child: child,
          );
        },
        child: Image.asset(
          widget.logoAssetPath,
          width: widget.size,
          height: widget.size,
          fit: widget.fit,
        ),
      ),
    );
  }
}

/// Extension methods to easily show rotating logo loaders in different contexts
extension RotatingLogoLoaderExtensions on BuildContext {
  /// Shows a snackbar with a rotating logo
  void showLoaderSnackbar({
    required String logoAssetPath,
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 60),
    double logoSize = 20,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 30, 
              height: 30,
              child: RotatingLogoLoader(
                logoAssetPath: logoAssetPath,
                size: logoSize,
              ),
            ),
            SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
  
  /// Hides any currently showing snackbar
  void hideLoaderSnackbar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
} 