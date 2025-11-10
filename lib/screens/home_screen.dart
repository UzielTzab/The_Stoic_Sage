import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/data/stoic_content_data.dart';
import 'package:stoic_app/models/stoic_content.dart';
import 'package:stoic_app/providers/favorite_lessons_provider.dart';
import 'package:stoic_app/providers/lesson_progress_provider.dart';
import 'package:stoic_app/providers/theme_provider.dart';
import 'package:stoic_app/theme/app_text_styles.dart';
import 'package:stoic_app/theme/app_colors.dart';
import 'package:stoic_app/widgets/lesson_list_item.dart';
import 'package:stoic_app/screens/lesson_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final List<MapEntry<String, List<StoicContent>>> _sectionEntries;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    final grouped = _groupContentByCategory(stoicContentData);
    _sectionEntries = grouped.entries.toList(growable: false);
    // Ensure the home screen starts in light mode the first time it opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setLightMode();
    });
  }

  LinkedHashMap<String, List<StoicContent>> _groupContentByCategory(
    List<StoicContent> content,
  ) {
    final grouped = LinkedHashMap<String, List<StoicContent>>();
    for (final lesson in content) {
      grouped.putIfAbsent(lesson.category, () => []).add(lesson);
    }
    return grouped;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final progressProvider = context.watch<LessonProgressProvider>();
    final favoriteProvider = context.watch<FavoriteLessonsProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            //Navegar al login
            Navigator.of(context).pushNamed('/login');
          },
          icon: Icon(Icons.arrow_back, color: context.textPrimary, size: 22),
        ),
        elevation: 0,
        title: Text(
          "Inicio",
          style: AppTextStyles.appBarCaption.copyWith(
            color: context.textSecondary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(
              themeProvider.themeModeIcon,
              color: context.textPrimary,
              size: 22,
            ),
            tooltip: themeProvider.themeModeText,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: context.textPrimary, size: 22),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Inicio
          SafeArea(
            child: Column(
              children: [
                // Header section
                // Header section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 100,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Decoración con plantas y libros (fondo)
                        Positioned(
                          right: -40,
                          top: -20,
                          child: SizedBox(
                            width: 200,
                            height: 150,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  top: 13,
                                  child: Transform.rotate(
                                    angle: 0.25,
                                    child: Image.asset(
                                      'assets/images/stack_book.png',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Image.asset(
                                    'assets/images/base_rose.png',
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Columna con título y barra de búsqueda
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Estoicismo",
                                  style: AppTextStyles.brandTitleSecondary
                                      .copyWith(color: context.textPrimary),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: context.dividerColor.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                  ),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Buscar lección",
                                      hintStyle: AppTextStyles.inputHint
                                          .copyWith(
                                            color: context.textSecondary,
                                          ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: context.textSecondary,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),

                // Sections and Lessons list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                    itemCount: _sectionEntries.length,
                    itemBuilder: (context, sectionIndex) {
                      final section = _sectionEntries[sectionIndex];
                      final lessons = section.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                            child: Text(
                              section.key.toUpperCase(),
                              style: AppTextStyles.overlineStrong.copyWith(
                                color: context.textSecondary,
                              ),
                            ),
                          ),

                          // Lessons in this section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: lessons.map((lesson) {
                                final status = progressProvider.statusFor(
                                  lesson.id,
                                  fallback: lesson.status,
                                );
                                final isCompleted =
                                    status == LessonStatus.completed;
                                final isFavorite = favoriteProvider.isFavorite(
                                  lesson.id,
                                  fallback: lesson.isFavorite,
                                );
                                final imagePath = isCompleted
                                    ? "assets/images/open_book.png"
                                    : "assets/images/close_book.png";

                                return LessonListItem(
                                  title: lesson.title,
                                  subtitle: lesson.description,
                                  imagePath: imagePath,
                                  status: status,
                                  isFavorite: isFavorite,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            LessonDetailScreen(content: lesson),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),

                          // Spacing between sections
                          if (sectionIndex < _sectionEntries.length - 1)
                            const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab 2: Filósofos
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, size: 64, color: context.textSecondary),
                const SizedBox(height: 16),
                Text(
                  "Filósofos",
                  style: AppTextStyles.h3.copyWith(color: context.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  "Explora las enseñanzas de los grandes maestros",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Tab 3: Glosario
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book, size: 64, color: context.textSecondary),
                const SizedBox(height: 16),
                Text(
                  "Glosario",
                  style: AppTextStyles.h3.copyWith(color: context.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  "Diccionario de términos estoicos",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Tab 4: Conversar IA
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat, size: 64, color: context.textSecondary),
                const SizedBox(height: 16),
                Text(
                  "Conversar IA",
                  style: AppTextStyles.h3.copyWith(color: context.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  "Chatea con un asistente estoico",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: context.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          labelStyle: AppTextStyles.tabLabel,
          unselectedLabelStyle: AppTextStyles.tabLabel,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Inicio"),
            Tab(icon: Icon(Icons.book_rounded), text: "Filósofos"),
            Tab(icon: Icon(Icons.school), text: "Glosario"),
            Tab(icon: Icon(Icons.auto_awesome), text: "Chat IA"),
          ],
        ),
      ),
    );
  }
}
