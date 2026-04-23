import 'dart:math' as math;
import 'package:flutter/material.dart';

class RestRingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color background;
  final Color foreground;
  final double strokeWidth;

  const RestRingPainter({
    required this.progress,
    required this.background,
    required this.foreground,
    this.strokeWidth = 10,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth / 2;

    final bgPaint = Paint()
      ..color = background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = foreground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RestRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.background != background ||
        oldDelegate.foreground != foreground ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class RestCirclePro extends StatelessWidget {
  final int restTotal;
  final int restRemaining;

  // UI config
  final double size;
  final double strokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final TextStyle timeStyle;
  final TextStyle labelStyle;
  final String label;

  const RestCirclePro({
    super.key,
    required this.restTotal,
    required this.restRemaining,
    this.size = 160,
    this.strokeWidth = 12,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.timeStyle,
    required this.labelStyle,
    this.label = "sec",
  });

  @override
  Widget build(BuildContext context) {
    final total = restTotal <= 0 ? 1 : restTotal;
    final remaining = restRemaining;
    final progress = 1 - (remaining / total);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: RestRingPainter(
          progress: progress,
          background: backgroundColor,
          foreground: foregroundColor,
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("$remaining", style: timeStyle),
              Text(label, style: labelStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class MyProgressBar extends StatelessWidget {
  final double value; // 0.0 - 1.0
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final BorderRadius? borderRadius;
  final Duration duration;

  const MyProgressBar({
    super.key,
    required this.value,
    this.height = 20,
    this.backgroundColor = Colors.white,
    this.progressColor = Colors.blue,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final fullWidth = constraints.maxWidth;
        final progressWidth = fullWidth * clampedValue;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius ?? BorderRadius.circular(999),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOut,
                width: progressWidth,
                height: height,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: borderRadius ?? BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
