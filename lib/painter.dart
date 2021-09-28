import 'package:flutter/material.dart';
import 'package:sketching_app/point.dart';
import 'dart:ui';

class MyPainter extends CustomPainter {
  final List<SketchPoint?> _sketchPoints;

  MyPainter(this._sketchPoints) : super();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _sketchPoints.length; i++) {
      if (i == 0) {
        canvas.drawPoints(PointMode.points, [_sketchPoints[i]!.position],
            _sketchPoints[i]!.paint);
      } else if (_sketchPoints[i - 1] != null && _sketchPoints[i] != null) {
        canvas.drawLine(_sketchPoints[i - 1]!.position,
            _sketchPoints[i]!.position, _sketchPoints[i]!.paint);
      }
    }
  }

  @override
  // Should repaint everything when a change is made
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
