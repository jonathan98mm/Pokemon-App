# Pokémon App - Clean Architecture 📱

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Clean-Architecture-green?style=for-the-badge)

Una aplicación móvil moderna para visualizar información relevante sobre la saga Pokémon, desarrollada siguiendo los principios de **Clean Architecture**.

La aplicación consume la [PokeAPI](https://pokeapi.co/) y demuestra el uso de patrones de diseño avanzados, generación de código y manejo de estado robusto.

## 🛠 Tech Stack

El proyecto utiliza las siguientes librerías clave:

- **Arquitectura:** Clean Architecture con separación de capas (Domain, Data, Presentation).
- **Estado:** `provider` para la inyección de dependencias y manejo de estado.
- **Routing:** `go_router` para la navegación declarativa.
- **Modelos & Datos:**
  - `freezed` & `json_serializable` para modelos inmutables y serialización.
  - `hive` para almacenamiento local (NoSQL).
- **UI/UX:**

  - `skeletonizer` para efectos de carga.
  - `extended_image` para caché de imágenes avanzado.
  - `google_fonts` para tipografía.

- **Internacionalización:** `slang` (Type-safe i18n).
- **Audio:** `flutter_soloud` para efectos de sonido de baja latencia.
- **Entorno:** `flutter_dotenv` para manejo de variables sensibles.

---

## 🚀 Guía de Instalación y Desarrollo

Sigue estos pasos para ejecutar el proyecto en tu máquina local.

### 1. Prerrequisitos

- Flutter SDK (Versión compatible con SDK `^3.9.2`).
- Android Studio / VS Code configurados.

### 2. Clonar y obtener dependencias

```bash
git clone https://github.com/jonathan98mm/Pokemon-App.git
cd Pokemon-App
flutter pub get
```

### 3. Generar Archivos de Código

Este proyecto utiliza `freezed`, `hive` y `slang`. Debes generar los archivos `.g.dart` y `.freezed.dart` manualmente:

```bash
dart run build_runner build -d
```

Y... para generar las traducciones:

```bash
dart run slang
```

### 4. Configuración de Variables de Entorno (.env)

Crea un archivo llamado `.env` en la raíz del proyecto (al mismo nivel que el pubspec.yaml) y agrega la URL base de la API:

```
BASE_URL=https://pokeapi.co/api/v2/
```

### 5. Ejecutar la App

Una vez completados los pasos anteriores:

```bash
flutter run
```
