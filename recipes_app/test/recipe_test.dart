import 'package:flutter_test/flutter_test.dart';
import 'package:recipes_app/models/recipe.dart';

void main() {
  test('Recipe.fromJson convierte JSON a objeto Recipe', () {
    final json = {
      "idMeal": "1234",
      "strMeal": "Pasta Test",
      "strMealThumb": "https://www.example.com/img.jpg",
      "strInstructions": "Cocinar la pasta en agua con sal.",
      "strIngredient1": "Pasta",
      "strIngredient2": "Sal",
      "strIngredient3": null,
    };

    final recipe = Recipe.fromJson(json);

    expect(recipe.id, "1234");
    expect(recipe.name, "Pasta Test");
    expect(recipe.thumbnail, contains("img.jpg"));
    expect(recipe.instructions, contains("Cocinar"));
    expect(recipe.ingredients, contains("Pasta"));
    expect(recipe.ingredients, contains("Sal"));
  });
}