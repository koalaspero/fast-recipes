import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:recipes_app/controllers/recipe_controller.dart';
import 'package:recipes_app/controllers/theme_controller.dart';
import 'package:recipes_app/views/search_page.dart';


void main() {
  testWidgets('SearchPage muestra texto inicial',
      (WidgetTester tester) async {
    Get.put(RecipeController());
    Get.put(ThemeController());

    await tester.pumpWidget(GetMaterialApp(home: SearchPage()));

    // Verificar que el mensaje inicial está en pantalla
    expect(find.text('Escribe un ingrediente para buscar.'), findsOneWidget);
  });
}
