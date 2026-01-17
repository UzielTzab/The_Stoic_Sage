import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stoic_app/models/stoic_content.dart';
import 'package:stoic_app/providers/favorite_lessons_provider.dart';
import 'package:stoic_app/providers/lesson_progress_provider.dart';
import 'package:stoic_app/providers/philosophers_provider.dart';
import 'package:stoic_app/providers/stoic_content_provider.dart';
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
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _searchController = TextEditingController();
    // Ensure the home screen starts in light mode the first time it opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setLightMode();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final progressProvider = context.watch<LessonProgressProvider>();
    final favoriteProvider = context.watch<FavoriteLessonsProvider>();
    final contentProvider = context.watch<StoicContentProvider>();

    final filteredLessons = contentProvider.searchLessons(_searchQuery);

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
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: Container(
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
                                      controller: _searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          _searchQuery = value;
                                        });
                                      },
                                      textInputAction: TextInputAction.search,
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
                                        suffixIcon: _searchQuery.isNotEmpty
                                            ? IconButton(
                                                tooltip: 'Limpiar búsqueda',
                                                icon: Icon(
                                                  Icons.close,
                                                  color: context.textSecondary,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _searchQuery = '';
                                                    _searchController.clear();
                                                  });
                                                },
                                              )
                                            : null,
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
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

                // Lessons list (sin encabezados de sección)
                Expanded(
                  child: filteredLessons.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: context.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Sin coincidencias",
                                style: AppTextStyles.h3.copyWith(
                                  color: context.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Intenta con otro término o limpia la búsqueda",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: context.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount: filteredLessons.length,
                          itemBuilder: (context, index) {
                            final lesson = filteredLessons[index];
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
                          },
                        ),
                ),
              ],
            ),
          ),

          // Tab 2: Filósofos
          SafeArea(
            child: Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filósofos",
                        style: AppTextStyles.h1.copyWith(
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Container(
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
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: "Buscar filósofo",
                              hintStyle: AppTextStyles.inputHint.copyWith(
                                color: context.textSecondary,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: context.textSecondary,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      tooltip: 'Limpiar búsqueda',
                                      icon: Icon(
                                        Icons.close,
                                        color: context.textSecondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _searchQuery = '';
                                          _searchController.clear();
                                        });
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Philosophers list
                Expanded(
                  child: Consumer<PhilosophersProvider>(
                    builder: (context, philosophersProvider, child) {
                      if (philosophersProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (philosophersProvider.error != null) {
                        return Center(
                          child: Text(
                            'Error: ${philosophersProvider.error}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.textSecondary,
                            ),
                          ),
                        );
                      }

                      final filteredPhilosophers =
                          philosophersProvider.searchPhilosophers(_searchQuery);

                      if (filteredPhilosophers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: context.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Sin coincidencias",
                                style: AppTextStyles.h3.copyWith(
                                  color: context.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Intenta con otro término o limpia la búsqueda",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: context.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount: filteredPhilosophers.length,
                        itemBuilder: (context, index) {
                          final philosopher = filteredPhilosophers[index];
                          final status = progressProvider.statusFor(
                            philosopher.id,
                            fallback: philosopher.status,
                          );
                          final isCompleted = status == LessonStatus.completed;
                          final imagePath = isCompleted
                              ? "assets/images/open_book.png"
                              : "assets/images/close_book.png";

                          return LessonListItem(
                            title: philosopher.title,
                            subtitle: philosopher.description,
                            imagePath: imagePath,
                            status: status,
                            isFavorite: false, // Philosophers don't have favorites for now
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonDetailScreen(
                                    content: philosopher,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
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

          // Tab 4: Favoritos
          SafeArea(
            child: Column(
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Favoritos",
                        style: AppTextStyles.brandTitleSecondary.copyWith(
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Tus lecciones guardadas",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Favoritos list
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final contentProvider = Provider.of<StoicContentProvider>(
                        context,
                      );
                      final favoriteLessons = contentProvider.lessons.where((
                        lesson,
                      ) {
                        return favoriteProvider.isFavorite(
                          lesson.id,
                          fallback: lesson.isFavorite,
                        );
                      }).toList();

                      if (favoriteLessons.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 64,
                                color: context.textSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No hay favoritos",
                                style: AppTextStyles.h3.copyWith(
                                  color: context.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Agrega lecciones tocando el corazón",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: context.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        itemCount: favoriteLessons.length,
                        itemBuilder: (context, index) {
                          final lesson = favoriteLessons[index];
                          final status = progressProvider.statusFor(
                            lesson.id,
                            fallback: lesson.status,
                          );
                          final isCompleted = status == LessonStatus.completed;
                          final imagePath = isCompleted
                              ? "assets/images/open_book.png"
                              : "assets/images/close_book.png";

                          return LessonListItem(
                            title: lesson.title,
                            subtitle: lesson.description,
                            imagePath: imagePath,
                            status: status,
                            isFavorite: true,
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
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab 5: Conversar IA
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/chat');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Abrir Chat',
                    style: TextStyle(color: Colors.white),
                  ),
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
            Tab(icon: Icon(Icons.favorite), text: "Favoritos"),
            Tab(icon: Icon(Icons.auto_awesome), text: "Chat IA"),
          ],
        ),
      ),
    );
  }
}
