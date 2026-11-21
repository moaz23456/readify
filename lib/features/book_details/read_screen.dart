import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';

class ReadScreen extends StatelessWidget {
  final Book book;

  const ReadScreen({super.key, required this.book});

  // TODO(API): النص ده وهمي، هيتبدل بعارض PDF
  static const _sampleText =
      'This is a placeholder for the book text. When the API is ready, '
      'this screen will show the real book content as a PDF, and it will '
      'remember the last page you reached.\n\n'
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
      'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut '
      'aliquip ex ea commodo consequat.\n\n'
      'Duis aute irure dolor in reprehenderit in voluptate velit esse '
      'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
      'cupidatat non proident, sunt in culpa qui officia deserunt mollit '
      'anim id est laborum.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: BookCover(url: book.coverUrl, width: 220, height: 160),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '( 1 )',
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            _sampleText,
            style: TextStyle(fontSize: 18, height: 1.7),
          ),
        ],
      ),
    );
  }
}