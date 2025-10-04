
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_app/controllers/favorites_controller.dart';
import 'package:recipes_app/models/recipe.dart';
import 'package:recipes_app/routes/app_routes.dart';
import '../controllers/theme_controller.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // Inyección de controladores GetX
  final FavoritesController favController = Get.find();
  final ThemeController themeC = Get.find();

  @override
  void initState() {
    super.initState();
    favController.loadFavorites(); // Carga inicial de recetas favoritas desde la BD
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLight = themeC.themeMode.value == ThemeMode.light;

      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Favoritos',
            style: TextStyle(color: isLight ? Colors.black : Colors.white),
          ),
          backgroundColor: isLight ? null : Colors.grey[900],
          iconTheme: IconThemeData(color: isLight ? Colors.black : Colors.white),
        ),
        body: Obx(() {
          final list = favController.favorites; // Lista reactiva de favoritos

          // Estado vacío - Sin recetas guardadas
          if (list.isEmpty) {
            return Center(
              child: Text(
                'No hay recetas guardadas',
                style: TextStyle(color: isLight ? Colors.black : Colors.white),
              ),
            );
          }

          // Lista de recetas favoritas
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: isLight ? Colors.grey[300] : Colors.grey[700],
            ),
            itemBuilder: (context, index) {
              final Recipe r = list[index];
              return ListTile(
                // Thumbnail de la receta
                leading: r.thumbnail.isNotEmpty
                    ? Image.network(r.thumbnail, width: 56, height: 56, fit: BoxFit.cover)
                    : SizedBox(width: 56, height: 56),
                // Nombre de la receta
                title: Text(
                  r.name,
                  style: TextStyle(color: isLight ? Colors.black : Colors.white),
                ),
                // Primeros 3 ingredientes como preview
                subtitle: Text(
                  r.ingredients.take(3).join(', '),
                  style: TextStyle(color: isLight ? Colors.grey[700] : Colors.grey[300]),
                ),
                // Navegación a detalle de receta
                onTap: () {
                  Get.toNamed(AppRoutes.detail, arguments: r);
                },
                // Botón de eliminación con confirmación
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: isLight ? Colors.red : Colors.red[300]),
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Eliminar',
                      middleText: '¿Eliminar ${r.name} de favoritos?',
                      textConfirm: 'Sí',
                      textCancel: 'Cancelar',
                      onConfirm: () async {
                        await favController.removeFavorite(r.id);
                        Navigator.of(Get.overlayContext!).pop();
                      },
                      onCancel: () => Navigator.of(Get.overlayContext!).pop(),
                    );
                  },
                ),
              );
            },
          );
        }),
      );
    });
  }
}