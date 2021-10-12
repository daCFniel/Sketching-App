import 'package:flutter/material.dart';

class MyBrush with ChangeNotifier {
  double _lineThickness = 25.0;

  double get lineThickness => _lineThickness;

  set lineThickness(double newValue) {
    _lineThickness = newValue;
    notifyListeners();
  }
}
