# 🍳 Recipes App

Una aplicación móvil desarrollada en Flutter que permite buscar recetas por ingredientes y gestionar tus favoritos para acceso rápido.

## 📱 Descripción

Recipes App resuelve el problema común de decidir qué cocinar con los ingredientes disponibles en casa. La aplicación integra una API externa de recetas con almacenamiento local para ofrecer una experiencia fluida tanto online como offline.

## ✨ Características

- **🔍 Búsqueda en tiempo real** por ingredientes
- **❤️ Gestión de favoritos** con persistencia local
- **🌙 Tema claro/oscuro** adaptable
- **📱 Interfaz intuitiva** en español
- **⚡ Navegación fluida** entre pantallas
- **💾 Funcionalidad offline** para recetas guardadas

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework de UI
- **GetX** - Gestión de estado, rutas y dependencias
- **HTTP** - Cliente para consumo de APIs REST
- **SQLite** - Base de datos local para persistencia
- **TheMealDB API** - Fuente de datos de recetas

## 🏗️ Arquitectura

```
lib/
├── controllers/          # Gestión de estado con GetX
├── models/              # Modelos de datos
├── views/               # Interfaces de usuario
├── services/            # Capa de acceso a datos
├── routes/              # Configuración de navegación
└── theme/               # Definiciones de temas
```

## 📦 Instalación

1. **Clona el repositorio**
   ```bash
   https://github.com/koalaspero/fast-recipes.git
   cd recipes-app
   ```

2. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

## 🚀 Uso

1. **Búsqueda**: Ingresa un ingrediente en la pantalla principal
2. **Resultados**: Explora las recetas disponibles
3. **Detalle**: Toca cualquier receta para ver ingredientes e instrucciones
4. **Favoritos**: Guarda recetas para acceso rápido sin conexión
5. **Tema**: Alterna entre modo claro y oscuro según tu preferencia

## 🎯 Funcionalidades Principales

### Búsqueda de Recetas
- Consulta en tiempo real a TheMealDB API
- Filtrado por ingredientes principales
- Resultados con imágenes y nombres

### Gestión de Favoritos
- Almacenamiento local con SQLite
- Adición y eliminación con confirmación
- Acceso offline completo

### Experiencia de Usuario
- Interfaz adaptativa a tema claro/oscuro
- Navegación fluida entre pantallas
- Manejo de estados de carga y error

## 🔧 Configuración Técnica

### Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  http: ^1.2.1
  sqflite: ^2.3.3
  path: ^1.9.0
```

### Estructura de Controladores
- `RecipeController`: Gestión de búsquedas y datos de API
- `FavoritesController`: Administración de recetas favoritas
- `ThemeController`: Control de temas visuales

---

**Desarrollado con ❤️ usando Flutter y GetX**