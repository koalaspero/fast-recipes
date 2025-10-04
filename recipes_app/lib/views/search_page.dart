import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_app/controllers/theme_controller.dart';
import '../controllers/recipe_controller.dart';
import '../routes/app_routes.dart';

class SearchPage extends StatelessWidget {
  // Inyección de controladores GetX
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
            // Botón para alternar tema claro/oscuro
            IconButton(
              icon: Icon(isLight ? Icons.light_mode : Icons.dark_mode),
              onPressed: themeC.toggleTheme,
              tooltip: 'Cambiar tema',
            ),
            // Navegación a pantalla de favoritos
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () => Get.toNamed(AppRoutes.favorites),
              tooltip: 'Favoritos',
            ),
          ],
        ),
        body: Column(
          children: [
            // Barra de búsqueda
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
                      // Búsqueda al presionar Enter
                      onSubmitted: (value) =>
                          controller.searchRecipes(value.toLowerCase().trim()),
                    ),
                  ),
                  // Botón de búsqueda manual
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
            // Resultados de búsqueda
            Expanded(
              child: controller.isLoading.value
                  ? Center(child: CircularProgressIndicator()) // Estado de carga
                  : controller.recipes.isEmpty
                      ? Center( // Estado vacío - sin búsquedas
                          child: Text(
                            'Escribe un ingrediente para buscar.',
                            style:
                                TextStyle(color: isLight ? Colors.black : Colors.white),
                          ),
                        )
                      : ListView.builder( // Lista de resultados
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
                              // Navegación a detalle de receta
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