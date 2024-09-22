import 'package:flutter/material.dart';

enum ColorOptions { mainColor, white, red, black, purple }

class ConstantColors {
  static getColor(ColorOptions option) {
    switch (option) {
      case ColorOptions.red:
        return Colors.red;
      case ColorOptions.white:
        return Colors.white;
      case ColorOptions.purple:
        return Colors.purple;
      case ColorOptions.mainColor:
        return Color.fromARGB(255, 167, 70, 70);
      default:
        return Colors.black;
    }
  }
}
