import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bubble {
  final Color color;
  final double size;
  final double speed;
  final Offset startOffset;
  Bubble({required this.color, required this.size, required this.speed, required this.startOffset});
}

class BubblePainter extends CustomPainter {
  final double animationValue;
  final List<Bubble> bubbles;

  BubblePainter({required this.animationValue, required this.bubbles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      double x = size.width * bubble.startOffset.dx;
      double y = (size.height * bubble.startOffset.dy + size.height * bubble.speed * animationValue) %
              (size.height + bubble.size * 2) -
          bubble.size;

      final paint = Paint()
        ..color = bubble.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0);

      canvas.drawCircle(Offset(x, y), bubble.size / 2, paint);

      if (y > -bubble.size) {
        canvas.drawCircle(
          Offset(x, y),
          bubble.size / 2,
          Paint()
            ..color = Colors.white.withOpacity(0.05)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3.0
            ..maskFilter = MaskFilter.blur(BlurStyle.outer, 5.0),
        );
      }
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

class BubblesBackground extends StatefulWidget {
  const BubblesBackground({super.key});

  @override
  State<BubblesBackground> createState() => _BubblesBackgroundState();
}

class _BubblesBackgroundState extends State<BubblesBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 25),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BubblePainter(
            animationValue: _controller.value,
            bubbles: [
              Bubble(color: Colors.white.withOpacity(0.15), size: 100.w, speed: 0.005, startOffset: const Offset(0.3, 0.7)),
              Bubble(color: Colors.white.withOpacity(0.10), size: 150.w, speed: 0.003, startOffset: const Offset(0.8, 0.2)),
              Bubble(color: Colors.white.withOpacity(0.12), size: 70.w, speed: 0.008, startOffset: const Offset(0.1, 0.4)),
              Bubble(color: Colors.white.withOpacity(0.08), size: 180.w, speed: 0.002, startOffset: const Offset(0.6, 0.9)),
            ],
          ),
          child: Container(),
        );
      },
    );
  }
}
