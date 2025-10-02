import 'package:get/get.dart';
import 'package:recipes_app/models/recipe.dart';
import '../services/db_service.dart';

class FavoritesController extends GetxController {
  var favorites = <Recipe>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites(); // carga inicial apenas se crea el controller
  }

  /// Cargar todos los favoritos desde SQLite
  Future<void> loadFavorites() async {
    try {
      favorites.value = await DBService.getFavorites();
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar favoritos: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Agregar receta a favoritos
  Future<void> addFavorite(Recipe recipe) async {
    try {
      // Evitar duplicados
      final already = favorites.any((r) => r.id == recipe.id);
      if (already) {
        Get.snackbar('Aviso', '${recipe.name} ya está en favoritos', snackPosition: SnackPosition.BOTTOM);
        return;
      }
      await DBService.insertRecipe(recipe);
      await loadFavorites();
      Get.snackbar('Guardado', '${recipe.name} fue agregado a favoritos', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Eliminar receta por id
  Future<void> removeFavorite(String id) async {
    try {
      await DBService.deleteRecipe(id);
      await loadFavorites();
      Get.snackbar('Eliminado', 'Receta eliminada de favoritos', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Saber si una receta ya está en favoritos (para UI)
  bool isFavorite(String id) {
    return favorites.any((r) => r.id == id);
  }
}
