<!-- # Copilot Instructions for implementation

## Project Overview
This is a Flutter application named "implementation", starting as a basic counter app. It demonstrates core Flutter concepts like stateful widgets and hot reload.

## Architecture
- **Entry Point**: [lib/main.dart](lib/main.dart) defines `MyApp` (stateless root) and `MyHomePage` (stateful counter).
- **Data Flow**: Simple state management with `setState` for counter updates.
- **UI Structure**: MaterialApp with Scaffold, AppBar, body (Column with Text widgets), and FloatingActionButton.

## Critical Workflows
- **Run App**: `flutter run` (supports hot reload with 'r' key).
- **Build**: `flutter build apk` or `flutter build ios` (Android build dir customized in [android/build.gradle.kts](android/build.gradle.kts) to `../../build` for shared builds).
- **Test**: `flutter test` (example in [test/widget_test.dart](test/widget_test.dart) tests counter tap).
- **Dependencies**: `flutter pub get` (defined in [pubspec.yaml](pubspec.yaml)).

## Project-Specific Conventions
- **Linting**: Uses `flutter_lints` package; rules in [analysis_options.yaml](analysis_options.yaml) include recommended Flutter lints.
- **Theming**: ColorScheme.fromSeed with deepPurple seed (change in [lib/main.dart](lib/main.dart#L18) for theme updates).
- **State Updates**: Always use `setState` for UI changes, as in `_incrementCounter` method.
- **Widget Patterns**: Prefer const constructors for stateless widgets (e.g., `const MyApp()`).

## Key Files
- [pubspec.yaml](pubspec.yaml): Dependencies and version.
- [android/build.gradle.kts](android/build.gradle.kts): Custom build dir setup.
- [lib/main.dart](lib/main.dart): Core app logic.
- [test/widget_test.dart](test/widget_test.dart): Widget testing example. -->