import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/services/library_controller.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/features/book_details/add_to_shelf_sheet.dart';
import 'package:readify/features/book_details/book_details_screen.dart';
import 'package:readify/features/home/data/home_repository.dart';

class FeedCard extends StatelessWidget {
  final FeedItem item;

  const FeedCard({super.key, required this.item});

  void _openDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailsScreen(book: item.book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRated = item.action == FeedAction.rated;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.chip,
                child: Icon(Icons.person, size: 26, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          isRated
                              ? '${item.userName} rated it  '
                              : '${item.userName} is reading',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isRated) _Stars(rating: item.rating),
                      ],
                    ),
                    Text(
                      item.timeAgo,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<List<Book>>(
                valueListenable: LibraryController.instance.favorites,
                builder: (_, __, ___) {
                  final liked =
                  LibraryController.instance.isFavorite(item.book.id);
                  return IconButton(
                    iconSize: 30,
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primary,
                    ),
                    onPressed: () =>
                        LibraryController.instance.toggleFavorite(item.book),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _openDetails(context),
                child: BookCover(
                  url: item.book.coverUrl,
                  width: 120,
                  height: 180,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _openDetails(context),
                      child: Text(
                        item.book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'by ${item.book.author}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShelfButton(book: item.book),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final int rating;

  const _Stars({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating ? Icons.star : Icons.star_border,
          size: 20,
          color: AppColors.primary,
        );
      }),
    );
  }
}