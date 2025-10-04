// theme_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable para el modo de tema, inicializado con el tema del sistema
  var themeMode = ThemeMode.system.obs;

  // Alterna entre tema claro y oscuro
  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
        // Si está en light → cambia a dark, si está en dark → cambia a light
  }
}