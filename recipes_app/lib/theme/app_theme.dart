import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    primaryColor: Colors.orange,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
  );

  static final dark = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
  );
}
