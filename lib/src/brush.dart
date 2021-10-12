import 'package:flutter/material.dart';

class MyBrush with ChangeNotifier {
  double _lineThickness = 25.0;
  Color _brushColor = Colors.deepOrange;

  double get lineThickness => _lineThickness;

  Color get brushColor => _brushColor;

  set lineThickness(double newValue) {
    _lineThickness = newValue;
    notifyListeners();
  }

  set brushColor(Color newValue) {
    _brushColor = newValue;
    notifyListeners();
  }
}
