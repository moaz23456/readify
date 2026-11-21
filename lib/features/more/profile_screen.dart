import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/services/library_controller.dart';
import 'package:readify/core/services/profile_photo.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/features/book_details/book_details_screen.dart';
import 'package:readify/features/more/see_all_books_screen.dart';
import 'package:readify/features/more/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _currentName() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final displayName = user?.displayName ?? '';
    return displayName.isNotEmpty
        ? displayName
        : (email.contains('@') ? email.split('@').first : 'Reader');
  }

  @override
  Widget build(BuildContext context) {
    final controller = LibraryController.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          controller.favorites,
          controller.shelves,
        ]),
        builder: (context, _) {
          final shelves = controller.shelves.value;
          final wantToRead = controller.booksOnShelf(Shelf.wantToRead);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 8),
              Center(
                child: ValueListenableBuilder<File?>(
                  valueListenable: ProfilePhoto.instance.photo,
                  builder: (_, file, __) {
                    return CircleAvatar(
                      radius: 55,
                      backgroundColor: AppColors.chip,
                      backgroundImage: file != null ? FileImage(file) : null,
                      child: file == null
                          ? const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primary,
                      )
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _currentName(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  '${shelves.length} books',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  label: const Text(
                    'SETTINGS',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Want to Read',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: wantToRead.isEmpty
                        ? null
                        : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeeAllBooksScreen(
                          title: 'Want to Read',
                          books: wantToRead,
                        ),
                      ),
                    ),
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (wantToRead.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No books here yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                SizedBox(
                  height: 165,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: wantToRead.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final Book book = wantToRead[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailsScreen(book: book),
                          ),
                        ),
                        child: BookCover(
                          url: book.coverUrl,
                          width: 110,
                          height: 165,
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          );
        },
      ),
    );
  }
}