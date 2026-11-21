import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/services/library_controller.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/features/book_details/add_to_shelf_sheet.dart';
import 'package:readify/features/book_details/read_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          ValueListenableBuilder<List<Book>>(
            valueListenable: LibraryController.instance.favorites,
            builder: (_, __, ___) {
              final liked = LibraryController.instance.isFavorite(book.id);
              return IconButton(
                iconSize: 32,
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_border,
                  color: AppColors.primary,
                ),
                onPressed: () =>
                    LibraryController.instance.toggleFavorite(book),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: BookCover(url: book.coverUrl, width: 200, height: 300),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReadScreen(book: book)),
                ),
                icon: const Icon(Icons.menu_book_outlined, size: 22),
                label: const Text('Read', style: TextStyle(fontSize: 17)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, 46),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: ShelfButton(book: book)),
            const SizedBox(height: 24),
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'by ${book.author}',
              style: const TextStyle(fontSize: 16, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'About the book',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              'وصف الكتاب هيجي من الـ API.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'About the author',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.chip,
                  child: Icon(Icons.person, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    book.author,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}