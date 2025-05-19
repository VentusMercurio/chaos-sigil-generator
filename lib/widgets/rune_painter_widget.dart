// lib/widgets/rune_painter_widget.dart
import 'package:flutter/material.dart';
import '../utils/rune_data.dart'; // Assuming Rune class is here

class RunePainterWidget extends StatelessWidget {
  final Rune rune;
  final double size; // The desired display size for the rune
  final Color color;
  final double strokeWidth;

  const RunePainterWidget({
    super.key,
    required this.rune,
    this.size = 64.0,
    this.color = Colors.redAccent,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RunePainter(
          runePath: rune.path,
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _RunePainter extends CustomPainter {
  final Path runePath;
  final Color color;
  final double strokeWidth;

  _RunePainter({
    required this.runePath,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round // Or StrokeCap.butt for sharper ends
      ..strokeJoin = StrokeJoin.miter // Or StrokeJoin.round
      ..strokeWidth = strokeWidth;

    // --- Path Scaling and Centering ---
    // Assumes runePath is defined in a standard coordinate system (e.g., 0-100 x 0-100)
    // We need to scale it to fit 'size' and center it.

    Rect originalBounds = runePath.getBounds();
    if (originalBounds.isEmpty) return; // Path is empty, nothing to draw

    // Calculate scale factor to fit the path within the target 'size'
    // while maintaining aspect ratio.
    double scaleX = size.width / originalBounds.width;
    double scaleY = size.height / originalBounds.height;
    double scale = min(scaleX, scaleY); // Use the smaller scale to fit entirely

    // Create a transformation matrix
    final Matrix4 matrix = Matrix4.identity();
    // 1. Translate to center the original path at (0,0) before scaling
    matrix.translate(-originalBounds.left - originalBounds.width / 2,
        -originalBounds.top - originalBounds.height / 2);
    // 2. Scale
    matrix.scale(scale, scale);
    // 3. Translate to the center of the CustomPaint canvas
    matrix.translate(size.width / 2, size.height / 2);

    Path transformedPath = runePath.transform(matrix.storage);

    canvas.drawPath(transformedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _RunePainter oldDelegate) {
    return oldDelegate.runePath != runePath ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Helper for min of two doubles if dart:math 'min' is not directly accessible
double min(double a, double b) => a < b ? a : b;
