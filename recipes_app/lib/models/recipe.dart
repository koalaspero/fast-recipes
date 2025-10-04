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

  // Constructor desde JSON de la API - Parsea estructura específica de TheMealDB
  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> ing = [];
    // Itera sobre los 20 posibles campos de ingredientes en la API
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      // Solo agrega ingredientes no vacíos
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        // Formato: "Ingrediente - Medida" o solo "Ingrediente"
        final line = (measure != null && measure.toString().trim().isNotEmpty)
            ? "$ingredient - $measure"
            : ingredient.toString();
        ing.add(line.trim());
      }
    }
    return Recipe(
      id: json['idMeal'] ?? '',       // Mapea idMeal → id
      name: json['strMeal'] ?? '',    // Mapea strMeal → name
      thumbnail: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ing,               // Lista procesada de ingredientes
    );
  }

  // Convierte a Map para almacenar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'instructions': instructions,
      'ingredients': ingredients.join('|'), // Serializa lista como string
    };
  }

  // Constructor desde Map de SQLite - Reconstruye objeto desde BD
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      thumbnail: map['thumbnail'],
      instructions: map['instructions'],
      ingredients: (map['ingredients'] as String).split('|'), // Deserializa string a lista
    );
  }
}