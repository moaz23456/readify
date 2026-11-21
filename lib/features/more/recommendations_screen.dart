import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/features/book_details/book_details_screen.dart';
import 'package:readify/features/more/see_all_books_screen.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  // TODO(API): الكتب دي وهمية، هتيجي من الـ API
  static final List<Book> _fantasy = List.generate(
    12,
        (i) => Book(
      id: 'f${i + 1}',
      title: 'Fantasy Book ${i + 1}',
      author: 'Author ${i + 1}',
    ),
  );

  static final List<Book> _fiction = List.generate(
    12,
        (i) => Book(
      id: 'x${i + 1}',
      title: 'Fiction Book ${i + 1}',
      author: 'Author ${i + 1}',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations for you')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommendations for you',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'Readify learns about your personal tastes from your ratings. '
                      'Keep rating books to increase the quality of your recommendations!',
                  style: TextStyle(fontSize: 15, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _Section(title: 'Fantasy', books: _fantasy),
          const SizedBox(height: 20),
          _Section(title: 'Fiction', books: _fiction),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Book> books;

  const _Section({required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SeeAllBooksScreen(title: title, books: books),
                ),
              ),
              child: const Text('See All'),
            ),
          ],
        ),
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final book = books[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailsScreen(book: book),
                  ),
                ),
                child: BookCover(url: book.coverUrl, width: 110, height: 165),
              );
            },
          ),
        ),
      ],
    );
  }
}