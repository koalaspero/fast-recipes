import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipes_app/controllers/theme_controller.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/controllers/favorites_controller.dart';
import 'package:recipes_app/controllers/recipe_controller.dart';

class DetailPage extends StatefulWidget {
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Inyección de controladores GetX
  final RecipeController recipeController = Get.find();
  late FavoritesController favController;
  final ThemeController themeC = Get.find();
  late final dynamic arg; // Argumentos de navegación

  @override
  void initState() {
    super.initState();
    favController = Get.put(FavoritesController()); // Inicializa controlador de favoritos
    arg = Get.arguments; // Obtiene argumentos pasados en la navegación
    _prepare(); // Prepara los datos de la receta
  }

  // Maneja diferentes tipos de argumentos para cargar la receta
  Future<void> _prepare() async {
    if (arg == null) {
      Get.snackbar('Error', 'No se recibió ninguna receta.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (arg is Recipe) {
      recipeController.selectedRecipe.value = arg; // Receta directa
    } else if (arg is String) {
      await recipeController.fetchRecipeById(arg); // ID de receta
    } else if (arg is Map && arg['id'] != null) {
      await recipeController.fetchRecipeById(arg['id'].toString()); // Mapa con ID
    } else {
      Get.snackbar('Error', 'Argumento inválido para detalle.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle')),
      body: Obx(() {
        final recipe = recipeController.selectedRecipe.value;
        final isLight = themeC.themeMode.value == ThemeMode.light;

        // Estados de carga y error
        if (recipeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (recipe == null) {
          return Center(
              child: Text('No hay datos para mostrar.',
                  style: TextStyle(color: isLight ? Colors.black : Colors.white)));
        }

        final isFav = favController.isFavorite(recipe.id);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen de la receta
              if (recipe.thumbnail.isNotEmpty)
                Center(
                  child: Image.network(
                    recipe.thumbnail,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 12),
              
              // Nombre de la receta
              Text(recipe.name,
                  style: Theme.of(context).textTheme.headlineSmall!
                      .copyWith(color: isLight ? Colors.black : Colors.white)),
              SizedBox(height: 8),
              
              // Lista de ingredientes
              Text('Ingredientes',
                  style: Theme.of(context).textTheme.bodyLarge!
                      .copyWith(color: isLight ? Colors.black : Colors.white)),
              SizedBox(height: 6),
              ...recipe.ingredients.map((ing) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, size: 18,
                            color: isLight ? Colors.black : Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(ing,
                              style: TextStyle(
                                  color: isLight ? Colors.black : Colors.white)),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 12),
              
              // Instrucciones en área de scroll
              Text('Instrucciones',
                  style: Theme.of(context).textTheme.bodyLarge!
                      .copyWith(color: isLight ? Colors.black : Colors.white)),
              SizedBox(height: 6),
              Container(
                height: 200,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isLight ? Colors.grey[200] : Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    recipe.instructions.isNotEmpty
                        ? recipe.instructions
                        : 'No hay instrucciones.',
                    style:
                        TextStyle(color: isLight ? Colors.black : Colors.white, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Botón de favoritos dinámico
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(isFav ? Icons.delete : Icons.favorite),
                      label: Text(
                        isFav ? 'Eliminar de favoritos' : 'Guardar en favoritos',
                      ),
                      onPressed: () async {
                        if (isFav) {
                          await favController.removeFavorite(recipe.id);
                        } else {
                          await favController.addFavorite(recipe);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}