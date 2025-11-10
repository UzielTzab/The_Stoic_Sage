import 'package:flutter/material.dart';

/// Provider para manejar el estado del tema (claro/oscuro)
/// Version básica sin persistencia (se puede añadir SharedPreferences después)
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Constructor
  ThemeProvider();

  /// Getter para el modo de tema actual
  ThemeMode get themeMode => _themeMode;

  /// Getter para saber si está en modo oscuro
  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        // En caso de system, usar el tema del sistema
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    }
  }

  /// Getter para saber si está en modo claro
  bool get isLightMode => !isDarkMode;

  /// Getter para el texto descriptivo del modo actual
  String get themeModeText {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Modo Oscuro';
      case ThemeMode.light:
        return 'Modo Claro';
      case ThemeMode.system:
        return 'Automático';
    }
  }

  /// Getter para el ícono del modo actual
  IconData get themeModeIcon {
    switch (_themeMode) {
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Cambia al modo oscuro
  void setDarkMode() {
    if (_themeMode != ThemeMode.dark) {
      _themeMode = ThemeMode.dark;
      notifyListeners();
    }
  }

  /// Cambia al modo claro
  void setLightMode() {
    if (_themeMode != ThemeMode.light) {
      _themeMode = ThemeMode.light;
      notifyListeners();
    }
  }

  /// Cambia al modo automático (del sistema)
  void setSystemMode() {
    if (_themeMode != ThemeMode.system) {
      _themeMode = ThemeMode.system;
      notifyListeners();
    }
  }

  /// Alterna entre modo claro y oscuro
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      setLightMode();
    } else {
      setDarkMode();
    }
  }

  /// Cambia a un modo específico
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Resetea el tema a modo automático
  void resetTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}

/// Extension para acceder fácilmente al ThemeProvider desde el contexto
extension ThemeProviderExtension on BuildContext {
  /// Shortcut para cambiar tema
  void toggleTheme() {
    // Esta función debe usarse con Provider.of<ThemeProvider>(context)
    // Ejemplo de uso: context.toggleTheme() requiere configurar el provider
  }

  /// Shortcut para saber si está en modo oscuro
  bool get isDarkTheme {
    return Theme.of(this).brightness == Brightness.dark;
  }
}
