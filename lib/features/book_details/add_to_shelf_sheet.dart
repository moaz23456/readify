import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/services/library_controller.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/features/book_details/add_to_shelf_screen.dart';

void showAddToShelfSheet(BuildContext context, Book book) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => AddToShelfScreen(book: book),
    ),
  );
}

class ShelfButton extends StatelessWidget {
  final Book book;

  const ShelfButton({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, Shelf>>(
      valueListenable: LibraryController.instance.shelves,
      builder: (_, shelves, __) {
        final shelf = shelves[book.id];
        final chosen = shelf != null;
        return ElevatedButton(
          onPressed: () => showAddToShelfSheet(context, book),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: chosen ? AppColors.chip : AppColors.primary,
            foregroundColor: chosen ? AppColors.primary : AppColors.onPrimary,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (chosen) ...[
                const Icon(Icons.check, size: 18),
                const SizedBox(width: 6),
              ],
              Text(
                shelf?.label ?? 'Want to read',
                style: const TextStyle(fontSize: 15),
              ),
              const Icon(Icons.arrow_drop_down, size: 24),
            ],
          ),
        );
      },
    );
  }
}