import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_app/controllers/favorites_controller.dart';
import 'package:recipes_app/controllers/recipe_controller.dart';
import 'package:recipes_app/controllers/theme_controller.dart';
import 'package:recipes_app/routes/app_routes.dart';
import 'package:recipes_app/theme/app_theme.dart';
import 'package:recipes_app/views/detail_page.dart';
import 'package:recipes_app/views/favorites_page.dart';
import 'package:recipes_app/views/search_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ThemeController()); 

  // Register controllers
  Get.lazyPut<RecipeController>(() => RecipeController());
  Get.put(FavoritesController());
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeC = Get.find<ThemeController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'Recetas Rápidas',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeC.themeMode.value,
        initialRoute: AppRoutes.search,
        getPages: [
          GetPage(name: AppRoutes.search, page: () => SearchPage()),
          GetPage(name: AppRoutes.detail, page: () => DetailPage()),
          GetPage(name: AppRoutes.favorites, page: () => FavoritesPage()),
        ],
      );
    });
  }
}