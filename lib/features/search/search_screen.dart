import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/features/search/data/search_repository.dart';
import 'package:readify/features/search/search_results_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repository = SearchRepository();
  final _controller = TextEditingController();
  late Future<List<BookCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _repository.getCategories();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openResults(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultsScreen(query: q)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Search',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: _openResults,
                style: const TextStyle(fontSize: 17),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search, color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<BookCategory>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  final categories = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: categories.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, i) {
                      final c = categories[i];
                      return GestureDetector(
                        onTap: () => _openResults(c.name),
                        child: Column(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.chip,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    c.icon,
                                    size: 40,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
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
    );
  }
}