class Recipe {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final List<String> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ing = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        final line = (measure != null && measure.toString().trim().isNotEmpty)
            ? "$ingredient - $measure"
            : ingredient.toString();
        ing.add(line.trim());
      }
    }
    return Recipe(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ing,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'instructions': instructions,
      'ingredients': ingredients.join('|'),
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      thumbnail: map['thumbnail'],
      instructions: map['instructions'],
      ingredients: (map['ingredients'] as String).split('|'),
    );
  }
}
