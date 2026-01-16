import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/providers/counter_provider.dart';
import 'package:stoic_app/providers/favorite_lessons_provider.dart';
import 'package:stoic_app/providers/lesson_progress_provider.dart';
import 'package:stoic_app/providers/stoic_content_provider.dart';
import 'package:stoic_app/providers/theme_provider.dart';
import 'package:stoic_app/theme/app_theme.dart';
import 'package:stoic_app/screens/login_screen.dart';
import 'package:stoic_app/screens/home_screen.dart';
import 'package:stoic_app/screens/register_screen.dart';
import 'package:stoic_app/screens/chat_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    //Hola Uziel Dev, quiero decirte que esta sección del archivo main.dart es muy importante
    //Aquí es donde se configura el proveedor de estado para toda la aplicación
    //Y además se definen las rutas de navegación entre las diferentes pantallas
    //Ahora también incluye el sistema de temas claro/oscuro

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CounterProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => StoicContentProvider()),
        ChangeNotifierProvider(create: (context) => LessonProgressProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteLessonsProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Stoic App',

            // Configuración de temas
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Rutas
            initialRoute: "/",
            routes: {
              "/": (context) => const LoginScreen(),
              "/home": (context) => const HomeScreen(),
              "/register": (context) => const RegisterScreen(),
              "/login": (context) => const LoginScreen(),
              "/chat": (context) => const ChatScreen(),
            },
          );
        },
      ),
    );
  }
}
