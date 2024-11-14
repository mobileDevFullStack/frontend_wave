import 'package:flutter/material.dart';


class ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutWidth;
  final double cutOutHeight;

  const ScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
    this.overlayColor = const Color(0x88000000),
    this.borderRadius = 12,
    this.borderLength = 30,
    this.cutOutWidth = 250,
    this.cutOutHeight = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: rect.center,
          width: cutOutWidth,
          height: cutOutHeight,
        ),
        Radius.circular(borderRadius),
      ));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(rect)
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: rect.center,
          width: cutOutWidth,
          height: cutOutHeight,
        ),
        Radius.circular(borderRadius),
      ))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()..color = overlayColor;
    canvas.drawPath(getOuterPath(rect), paint);

    final cutOut = Rect.fromCenter(
      center: rect.center,
      width: cutOutWidth,
      height: cutOutHeight,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final RRect rRect = RRect.fromRectAndRadius(
      cutOut,
      Radius.circular(borderRadius),
    );

    _drawCornerLines(canvas, rRect, borderPaint);
  }

  void _drawCornerLines(Canvas canvas, RRect rRect, Paint paint) {
    // Coins supérieurs gauches
    canvas.drawLine(
      Offset(rRect.left, rRect.top + borderLength),
      Offset(rRect.left, rRect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rRect.left, rRect.top),
      Offset(rRect.left + borderLength, rRect.top),
      paint,
    );

    // Coins supérieurs droits
    canvas.drawLine(
      Offset(rRect.right - borderLength, rRect.top),
      Offset(rRect.right, rRect.top),
      paint,
    );
    canvas.drawLine(
      Offset(rRect.right, rRect.top),
      Offset(rRect.right, rRect.top + borderLength),
      paint,
    );

    // Coins inférieurs gauches
    canvas.drawLine(
      Offset(rRect.left, rRect.bottom - borderLength),
      Offset(rRect.left, rRect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rRect.left, rRect.bottom),
      Offset(rRect.left + borderLength, rRect.bottom),
      paint,
    );

    // Coins inférieurs droits
    canvas.drawLine(
      Offset(rRect.right - borderLength, rRect.bottom),
      Offset(rRect.right, rRect.bottom),
      paint,
    );
    canvas.drawLine(
      Offset(rRect.right, rRect.bottom - borderLength),
      Offset(rRect.right, rRect.bottom),
      paint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

