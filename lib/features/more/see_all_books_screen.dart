import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/features/book_details/book_details_screen.dart';

class SeeAllBooksScreen extends StatelessWidget {
  final String title;
  final List<Book> books;

  const SeeAllBooksScreen({
    super.key,
    required this.title,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: books.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, i) {
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
      ),
    );
  }
}