import 'package:flutter/material.dart';

class MyBrush with ChangeNotifier {
  double _lineThickness = 25.0;
  Color _backgroundColor = const Color(0xFFABCEEB);

  double get lineThickness => _lineThickness;

  Color get backgroundColor => _backgroundColor;

  set lineThickness(double newValue) {
    _lineThickness = newValue;
    notifyListeners();
  }

  set backgroundColor(Color newValue) {
    _backgroundColor = newValue;
    notifyListeners();
  }
}
