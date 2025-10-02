import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:recipes_app/models/recipe.dart';
import 'dart:convert';

class RecipeController extends GetxController {
  var recipes = <Recipe>[].obs; // Lista reactiva de recetas obtenidas de search.php
  var selectedRecipe = Rxn<Recipe>(); // Receta seleccionada para detalle (nullable)
  var isLoading = false.obs; // Indicador de carga para UI

  /// Busca recetas por ingrediente usando search.php
  Future<void> searchRecipes(String ingredient) async {
    if (ingredient.isEmpty) {
      recipes.clear(); // Limpiar resultados si no hay búsqueda
      return;
    }

    try {
      isLoading.value = true; // Mostrar indicador de carga

      final url =
          'https://www.themealdb.com/api/json/v1/1/search.php?s=${Uri.encodeComponent(ingredient)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['meals'] != null) {
          // Convertir cada resultado JSON en objeto Recipe completo
          recipes.value = (data['meals'] as List)
              .map((e) => Recipe.fromJson(e))
              .toList();
        } else {
          recipes.clear();
          Get.snackbar(
            'Sin resultados',
            'No se encontraron recetas para "$ingredient".',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'La API respondió con status ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo cargar recetas: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false; // Ocultar indicador de carga
    }
  }

  /// Obtiene detalles completos de una receta por su ID usando lookup.php
  Future<void> fetchRecipeById(String id) async {
    try {
      isLoading.value = true; // Mostrar indicador de carga
      print('Id being sent: $id');

      final url =
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${Uri.encodeComponent(id)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
          final meal = data['meals'][0] as Map<String, dynamic>;
          selectedRecipe.value = Recipe.fromJson(meal); // Guardar receta completa
        } else {
          selectedRecipe.value = null;
          Get.snackbar(
            'No encontrado',
            'No se encontró la receta solicitada.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'La API respondió con status ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo obtener detalle: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false; // Ocultar indicador de carga
    }
  }
}
