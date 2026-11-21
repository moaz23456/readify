import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/core/widgets/brown_app_bar.dart';
import 'package:readify/features/book_details/book_details_screen.dart';
import 'package:readify/features/discover/data/discover_repository.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _repository = DiscoverRepository();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _repository.getPopularBooks();
  }

  void _reload() {
    setState(() {
      _booksFuture = _repository.getPopularBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrownAppBar(title: 'Discover'),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Something went wrong'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _reload,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final books = snapshot.data ?? [];
          if (books.isEmpty) {
            return const Center(child: Text('No books yet'));
          }

          return CustomScrollView(
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Popular',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.62,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, i) {
                      final book = books[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailsScreen(book: book),
                          ),
                        ),
                        child: BookCover(
                          url: book.coverUrl,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      );
                    },
                    childCount: books.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}