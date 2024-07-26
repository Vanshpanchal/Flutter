import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Define the initial color scheme
  var colorScheme = ColorScheme.fromSeed(seedColor: Colors.amber).obs;

  // Method to update the color scheme
  void updateColorScheme(Color color) {
    colorScheme.value = ColorScheme.fromSeed(seedColor: Colors.red);
  }
}
