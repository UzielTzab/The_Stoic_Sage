import 'package:flutter/material.dart';
import 'package:stoic_app/theme/app_colors.dart';
import 'package:stoic_app/theme/app_text_styles.dart';
import 'package:stoic_app/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  // Decoración superior con plantas
                  Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/plants.png',
                      width: 120,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox(width: 120, height: 100);
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Título con "El Sabio" en color especial
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
                        'Stoico',
                        style: AppTextStyles.brandTitleSecondary.copyWith(
                          color: context.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '"Cultiva las enseñanzas en tu propia vida"',
                    style: AppTextStyles.brandSubtitleItalic.copyWith(
                      color: context.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  Image.asset(
                    'assets/images/base_rose.png',
                    width: 100,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(width: 100, height: 120);
                    },
                  ),

                  const SizedBox(height: 32),

                  // Campo nombre de usuario
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nombre de usuario',
                      style: AppTextStyles.inputLabel.copyWith(
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: AppTextStyles.inputText.copyWith(
                      color: context.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      context,
                      hintText: 'Name example',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Campo correo electrónico
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Correo electrónico',
                      style: AppTextStyles.inputLabel.copyWith(
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.inputText.copyWith(
                      color: context.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      context,
                      hintText: '@example.com',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Campo contraseña
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tu contraseña',
                      style: AppTextStyles.inputLabel.copyWith(
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: AppTextStyles.inputText.copyWith(
                      color: context.textPrimary,
                    ),
                    decoration: _inputDecoration(
                      context,
                      hintText: '••••••••',
                      suffix: IconButton(
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

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
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
                        'Registrarse',
                        style: AppTextStyles.authButtonText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'o',
                    style: AppTextStyles.separatorText.copyWith(
                      color: context.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.textPrimary,
                        side: BorderSide(color: context.dividerColor, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                        'Registrarse con Google',
                        style: AppTextStyles.authButtonText.copyWith(
                          color: context.textPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '¿Ya tienes una cuenta?',
                      style: AppTextStyles.footerLink.copyWith(
                        color: context.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String hintText,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.inputHint.copyWith(
        color: context.textSecondary.withValues(alpha: 0.5),
      ),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      suffixIcon: suffix,
    );
  }
}
