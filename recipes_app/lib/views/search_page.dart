import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_app/controllers/theme_controller.dart';
import '../controllers/recipe_controller.dart';
import '../routes/app_routes.dart';


class SearchPage extends StatelessWidget {
  final RecipeController controller = Get.find();
  final TextEditingController textCtrl = TextEditingController();
  final ThemeController themeC = Get.find();

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLight = themeC.themeMode.value == ThemeMode.light;

      return Scaffold(
        appBar: AppBar(
          title: Text('Recetas Rápidas'),
          actions: [
            IconButton(
              icon: Icon(isLight ? Icons.light_mode : Icons.dark_mode),
              onPressed: themeC.toggleTheme,
              tooltip: 'Cambiar tema',
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => Get.toNamed(AppRoutes.favorites),
              tooltip: 'Favoritos',
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textCtrl,
                      decoration: InputDecoration(
                        hintText: 'Ingrediente (ej: chicken)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: isLight ? Colors.grey[200] : Colors.grey[850],
                      ),
                      style: TextStyle(
                        color: isLight ? Colors.black : Colors.white,
                      ),
                      onSubmitted: (value) =>
                          controller.searchRecipes(value.toLowerCase().trim()),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: isLight ? Colors.black : Colors.white,
                    ),
                    onPressed: () =>
                        controller.searchRecipes(textCtrl.text.trim()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : controller.recipes.isEmpty
                      ? Center(
                          child: Text(
                            'Escribe un ingrediente para buscar.',
                            style:
                                TextStyle(color: isLight ? Colors.black : Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = controller.recipes[index];
                            return ListTile(
                              leading: Image.network(
                                recipe.thumbnail,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                recipe.name,
                                style: TextStyle(
                                  color: isLight ? Colors.black : Colors.white,
                                ),
                              ),
                              onTap: () => Get.toNamed(
                                AppRoutes.detail,
                                arguments: recipe,
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      );
    });
  }
}
