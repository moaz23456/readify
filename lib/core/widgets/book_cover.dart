import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';

class BookCover extends StatelessWidget {
  final String url;
  final double width;
  final double height;

  const BookCover({
    super.key,
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: AppColors.chip,
      child: const Center(
        child: Icon(Icons.menu_book, size: 36, color: AppColors.primary),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: url.isEmpty
          ? placeholder
          : Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => placeholder,
      ),
    );
  }
}