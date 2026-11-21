import 'package:flutter/material.dart';
import 'package:readify/core/models/book.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/book_cover.dart';
import 'package:readify/features/book_details/add_to_shelf_sheet.dart';
import 'package:readify/features/book_details/book_details_screen.dart';
import 'package:readify/features/search/data/search_repository.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _repository = SearchRepository();
  late final TextEditingController _controller;
  late String _query;
  late Future<List<Book>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _query = widget.query;
    _controller = TextEditingController(text: _query);
    _resultsFuture = _repository.searchBooks(_query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    final q = value.trim();
    if (q.isEmpty) return;
    setState(() {
      _query = q;
      _resultsFuture = _repository.searchBooks(q);
    });
  }

  void _openDetails(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: _search,
              style: const TextStyle(fontSize: 17),
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _resultsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                final books = snapshot.data ?? [];
                if (books.isEmpty) {
                  return Center(
                    child: Text(
                      'No results for "$_query"',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Text(
                        '${books.length} results for "$_query"',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: books.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 24),
                        itemBuilder: (context, i) {
                          final book = books[i];
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _openDetails(book),
                                child: BookCover(
                                  url: book.coverUrl,
                                  width: 100,
                                  height: 150,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () => _openDetails(book),
                                      child: Text(
                                        book.title,
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
                                      'by ${book.author}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    ShelfButton(book: book),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}