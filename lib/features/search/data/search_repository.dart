import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';

class BookCategory {
  final String name;
  final IconData icon;

  const BookCategory({required this.name, required this.icon});
}

class SearchRepository {
  /// TODO(API): الـ endpoint: GET /api/v1/Categories
  Future<List<BookCategory>> getCategories() async {
    return const [
      BookCategory(name: 'Action', icon: Icons.sports_martial_arts),
      BookCategory(name: 'Sci-Fi', icon: Icons.rocket_launch_outlined),
      BookCategory(name: 'Thrillers', icon: Icons.local_fire_department),
      BookCategory(name: 'Arts', icon: Icons.palette_outlined),
      BookCategory(name: 'Biographies', icon: Icons.menu_book_outlined),
      BookCategory(name: 'Business', icon: Icons.work_outline),
      BookCategory(name: 'Romance', icon: Icons.favorite_border),
      BookCategory(name: 'Comedy', icon: Icons.sentiment_very_satisfied),
      BookCategory(name: 'Animation', icon: Icons.flight_outlined),
      BookCategory(name: 'Religion', icon: Icons.account_balance_outlined),
      BookCategory(name: 'Travel', icon: Icons.luggage_outlined),
      BookCategory(name: 'Politics', icon: Icons.apartment_outlined),
    ];
  }

  /// TODO(API): الـ endpoint: GET /api/v1/Books?search=...
  Future<List<Book>> searchBooks(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final all = List.generate(
      20,
          (i) => Book(
        id: 's${i + 1}',
        title: 'Zikola land ${i + 1}',
        author: 'Amr Abdel Hamid',
      ),
    );

    final q = query.trim().toLowerCase();
    return all.where((b) => b.title.toLowerCase().contains(q)).toList();
  }
}