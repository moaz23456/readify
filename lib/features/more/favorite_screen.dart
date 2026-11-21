import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/services/library_controller.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/core/widgets/brown_app_bar.dart';
import 'package:readify/features/book_details/book_details_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrownAppBar(title: 'Favorite'),
      body: ValueListenableBuilder<List<Book>>(
        valueListenable: LibraryController.instance.favorites,
        builder: (_, books, __) {
          if (books.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No favorites yet.\nTap the heart on any book to add it here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: books.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.6,
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
                child: Column(
                  children: [
                    Expanded(
                      child: BookCover(
                        url: book.coverUrl,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}