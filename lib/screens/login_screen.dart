import 'package:flutter/material.dart';
import 'package:stoic_app/theme/app_colors.dart';
import 'package:stoic_app/theme/app_text_styles.dart';
import 'package:stoic_app/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        // Removemos el backgroundColor ya que usaremos la imagen de fondo
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Imagen de fondo
            Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // En caso de error al cargar la imagen, mostrar un fondo sólido claro
                return Container(
                  color: Colors.white, // Siempre blanco en modo claro
                );
              },
            ),
            // Contenido encima de la imagen
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Botón de omitir (acceso rápido a la app)
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Text(
                            'Omitir',
                            style: AppTextStyles.linkMedium.copyWith(
                              color: AppColors.sabioAccent,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Título principal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'El Sabio ',
                            style: AppTextStyles.brandTitlePrimary.copyWith(
                              color: AppColors.sabioAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Estoico",
                            style: AppTextStyles.brandTitleSecondary.copyWith(
                              color: context.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Subtítulo / Frase
                      Text(
                        '"El obstáculo es tu camino"',
                        style: AppTextStyles.brandSubtitleItalic.copyWith(
                          color: context.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Campo de correo electrónico
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Correo electrónico',
                          style: AppTextStyles.inputLabel.copyWith(
                            color: AppColors.sabioAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: AppColors.sabioAccent,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.sabioAccent,
                        ),
                        decoration: InputDecoration(hintText: '@example.com'),
                      ),

                      const SizedBox(height: 24),

                      // Campo de contraseña
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Tu contraseña',
                          style: AppTextStyles.inputLabel.copyWith(
                            color: AppColors.sabioAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        cursorColor: AppColors.sabioAccent,
                        style: AppTextStyles.inputText.copyWith(
                          color: AppColors.sabioAccent,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: context.textSecondary,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 92),

                      // Botón de Iniciar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navegar a home
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.sabioAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Iniciar',
                            style: AppTextStyles.authButtonText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Texto "o"
                      Text(
                        'o',
                        style: AppTextStyles.separatorText.copyWith(
                          color: AppColors.sabioAccent,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Botón de Google
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Lógica de Google Sign-In
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white, width: 1),

                            backgroundColor: Colors.white,
                          ),
                          icon: Image.network(
                            'https://www.google.com/favicon.ico',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.g_mobiledata, size: 24);
                            },
                          ),
                          label: Text(
                            'Iniciar con Google',
                            style: AppTextStyles.authButtonText.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Acciones secundarias
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Navegar a recuperación de contraseña
                            },
                            child: Text(
                              '¿Olvidó la contraseña?',
                              style: AppTextStyles.footerLink.copyWith(
                                color: context.textSecondary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              '¿No tienes una cuenta? Regístrate',
                              style: AppTextStyles.footerLink.copyWith(
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
