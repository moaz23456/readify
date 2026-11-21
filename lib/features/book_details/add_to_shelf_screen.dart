import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/services/library_controller.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';

class AddToShelfScreen extends StatefulWidget {
  final Book book;

  const AddToShelfScreen({super.key, required this.book});

  @override
  State<AddToShelfScreen> createState() => _AddToShelfScreenState();
}

class _AddToShelfScreenState extends State<AddToShelfScreen> {
  Shelf? _selected;

  @override
  void initState() {
    super.initState();
    _selected = LibraryController.instance.shelves.value[widget.book.id];
  }

  void _confirm() {
    final shelf = _selected;
    if (shelf != null) {
      LibraryController.instance.setShelf(widget.book, shelf);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add to My Books'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: _selected == null
                  ? AppColors.textSecondary
                  : AppColors.primary,
            ),
            onPressed: _selected == null ? null : _confirm,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                BookCover(url: book.coverUrl, width: 70, height: 105),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${book.author}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              'SELECT A SHELF',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          for (final shelf in Shelf.values) ...[
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              title: Text(shelf.label, style: const TextStyle(fontSize: 17)),
              trailing: Icon(
                _selected == shelf
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: AppColors.primary,
              ),
              onTap: () => setState(() => _selected = shelf),
            ),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}