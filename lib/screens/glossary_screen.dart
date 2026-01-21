import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/models/glossary_term.dart';
import 'package:stoic_app/providers/glossary_provider.dart';
import 'package:stoic_app/providers/theme_provider.dart';
import 'package:stoic_app/screens/glossary_detail_screen.dart';
import 'package:stoic_app/theme/app_text_styles.dart';

class GlossaryScreen extends StatefulWidget {
  const GlossaryScreen({super.key});

  @override
  State<GlossaryScreen> createState() => _GlossaryScreenState();
}

class _GlossaryScreenState extends State<GlossaryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF232323)
          : const Color(0xFFF7F6F3),
      appBar: AppBar(
        backgroundColor: isDark
            ? const Color(0xFF232323)
            : const Color(0xFFF7F6F3),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF232323),
          ),
        ),
        title: Text(
          'Glosario Estoico',
          style: AppTextStyles.h3.copyWith(
            color: isDark ? Colors.white : const Color(0xFF232323),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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
      body: Consumer<GlossaryProvider>(
        builder: (context, glossaryProvider, child) {
          if (glossaryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (glossaryProvider.error != null) {
            return Center(
              child: Text(
                'Error: ${glossaryProvider.error}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
                ),
              ),
            );
          }

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar términos...',
                    hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: isDark ? Colors.white38 : const Color(0xFF6B6B6B),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.white38 : const Color(0xFF6B6B6B),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              glossaryProvider.setSearchQuery('');
                            },
                            icon: Icon(
                              Icons.clear,
                              color: isDark ? Colors.white38 : const Color(0xFF6B6B6B),
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? const Color(0xFF353535) : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF232323),
                  ),
                  onChanged: (value) {
                    glossaryProvider.setSearchQuery(value);
                  },
                ),
              ),

              // Categories filter
              if (glossaryProvider.categories.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: glossaryProvider.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              'Todos',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: glossaryProvider.selectedCategory == null
                                    ? Colors.white
                                    : (isDark ? Colors.white : const Color(0xFF232323)),
                              ),
                            ),
                            selected: glossaryProvider.selectedCategory == null,
                            onSelected: (selected) {
                              glossaryProvider.setSelectedCategory(null);
                            },
                            backgroundColor: isDark ? const Color(0xFF353535) : Colors.white,
                            selectedColor: const Color(0xFFFF6B35),
                            checkmarkColor: Colors.white,
                          ),
                        );
                      }

                      final category = glossaryProvider.categories[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: glossaryProvider.selectedCategory == category
                                  ? Colors.white
                                  : (isDark ? Colors.white : const Color(0xFF232323)),
                            ),
                          ),
                          selected: glossaryProvider.selectedCategory == category,
                          onSelected: (selected) {
                            glossaryProvider.setSelectedCategory(selected ? category : null);
                          },
                          backgroundColor: isDark ? const Color(0xFF353535) : Colors.white,
                          selectedColor: const Color(0xFFFF6B35),
                          checkmarkColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

              // Terms list
              Expanded(
                child: glossaryProvider.terms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: (isDark ? Colors.white38 : const Color(0xFF6B6B6B)).withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron términos',
                              style: AppTextStyles.h4.copyWith(
                                color: isDark ? Colors.white38 : const Color(0xFF6B6B6B),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: glossaryProvider.terms.length,
                        itemBuilder: (context, index) {
                          final term = glossaryProvider.terms[index];
                          return _GlossaryTermCard(
                            term: term,
                            isDark: isDark,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GlossaryDetailScreen(term: term),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlossaryTermCard extends StatelessWidget {
  final GlossaryTerm term;
  final bool isDark;
  final VoidCallback onTap;

  const _GlossaryTermCard({
    required this.term,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? const Color(0xFF353535) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      term.term,
                      style: AppTextStyles.h4.copyWith(
                        color: isDark ? Colors.white : const Color(0xFF232323),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      term.category,
                      style: AppTextStyles.overline.copyWith(
                        color: const Color(0xFFFF6B35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                term.definition,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white70 : const Color(0xFF6B6B6B),
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (term.relatedTerms.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: term.relatedTerms.take(3).map((relatedTerm) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : const Color(0xFF232323)).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        relatedTerm,
                        style: AppTextStyles.overline.copyWith(
                          color: isDark ? Colors.white60 : const Color(0xFF6B6B6B),
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}