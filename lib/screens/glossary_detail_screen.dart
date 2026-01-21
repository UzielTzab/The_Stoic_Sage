import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/models/glossary_term.dart';
import 'package:stoic_app/providers/glossary_provider.dart';
import 'package:stoic_app/providers/theme_provider.dart';
import 'package:stoic_app/theme/app_text_styles.dart';

class GlossaryDetailScreen extends StatelessWidget {
  final GlossaryTerm term;

  const GlossaryDetailScreen({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF232323)
          : const Color(0xFFF7F6F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : const Color(0xFF232323),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Glosario Estoico',
                          style: AppTextStyles.overlineStrong.copyWith(
                            color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
                          ),
                        ),
                        Text(
                          term.category,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFFFF6B35),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      themeProvider.toggleTheme();
                    },
                    icon: Icon(
                      themeProvider.themeModeIcon,
                      color: isDark ? Colors.white : const Color(0xFF232323),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Term title
                    Text(
                      term.term,
                      style: AppTextStyles.h1.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF232323),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Definition
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF353535) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: const Color(0xFFFF6B35),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Definición',
                                style: AppTextStyles.h4.copyWith(
                                  color: isDark ? Colors.white : const Color(0xFF232323),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            term.definition,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Related terms
                    if (term.relatedTerms.isNotEmpty) ...[
                      Text(
                        'Términos relacionados',
                        style: AppTextStyles.h4.copyWith(
                          color: isDark ? Colors.white : const Color(0xFF232323),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Consumer<GlossaryProvider>(
                        builder: (context, glossaryProvider, child) {
                          final relatedTerms = glossaryProvider.getRelatedTerms(term.term);
                          return Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: relatedTerms.map((relatedTerm) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GlossaryDetailScreen(term: relatedTerm),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6B35).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    relatedTerm.term,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFFFF6B35),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}