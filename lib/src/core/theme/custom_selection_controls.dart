import 'package:flutter/material.dart';

class CustomSelectionControls extends MaterialTextSelectionControls {
  static const double _lineWidth = 2.5;
  static const double _circleRadius = 7.0;
  static const double _kWidth = _circleRadius * 2;
  static const double _lineHeight = 20.0;
  static const double _kHeight = _circleRadius * 2 + _lineHeight;

  @override
  Size getHandleSize(double textLineHeight) => const Size(_kWidth, _kHeight);

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(_kWidth / 1.5, _kHeight);
      case TextSelectionHandleType.right:
       return const Offset(_kWidth / 3, _kHeight / 1.5);
      case TextSelectionHandleType.collapsed:
        return const Offset(_kWidth / 3, _kHeight / 1.5);
    }
  }

  @override
  Widget buildHandle(
      BuildContext context,
      TextSelectionHandleType type,
      double textHeight, [
        VoidCallback? onTap,
      ]) {
    final Color color = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: _kWidth,
        height: _kHeight,
        child: CustomPaint(
          painter: _HandlePainter(color: color, type: type),
        ),
      ),
    );
  }
}

class _HandlePainter extends CustomPainter {
  final Color color;
  final TextSelectionHandleType type;

  const _HandlePainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    const double r = CustomSelectionControls._circleRadius;
    const double lh = CustomSelectionControls._lineHeight;
    const double lw = CustomSelectionControls._lineWidth;

    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Paint linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = lw
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final Paint glossPaint = Paint()
      ..color = Colors.white.withAlpha(160)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    if (type == TextSelectionHandleType.left) {
      final Offset circleCentre = Offset(cx, r);
      canvas.drawLine(
        Offset(cx, r * 2),
        Offset(cx, r * 2 + lh),
        linePaint,
      );
      canvas.drawCircle(circleCentre, r, fillPaint);
      canvas.drawCircle(circleCentre, r * 0.38, glossPaint);
    } else {
      final Offset circleCentre = Offset(cx, lh + r);
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, lh),
        linePaint,
      );
      canvas.drawCircle(circleCentre, r, fillPaint);
      canvas.drawCircle(circleCentre, r * 0.38, glossPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HandlePainter old) =>
      old.color != color || old.type != type;
}