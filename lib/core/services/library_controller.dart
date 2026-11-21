import 'package:flutter/foundation.dart';
import 'package:readify/core/models/book.dart';

enum Shelf { read, currentlyReading, wantToRead }

extension ShelfLabel on Shelf {
  String get label {
    switch (this) {
      case Shelf.read:
        return 'Read';
      case Shelf.currentlyReading:
        return 'Currently Reading';
      case Shelf.wantToRead:
        return 'Want to Read';
    }
  }
}

class LibraryController {
  LibraryController._();
  static final LibraryController instance = LibraryController._();

  final ValueNotifier<List<Book>> favorites = ValueNotifier<List<Book>>([]);
  final ValueNotifier<Map<String, Shelf>> shelves =
  ValueNotifier<Map<String, Shelf>>({});

  // الكتب نفسها اللي اخترنا لها رف (علشان نعرضها في Profile)
  final Map<String, Book> _shelfBooks = {};

  bool isFavorite(String id) => favorites.value.any((b) => b.id == id);

  void toggleFavorite(Book book) {
    final list = List<Book>.from(favorites.value);
    if (isFavorite(book.id)) {
      list.removeWhere((b) => b.id == book.id);
    } else {
      list.add(book);
    }
    favorites.value = list;
  }

  void setShelf(Book book, Shelf shelf) {
    _shelfBooks[book.id] = book;
    shelves.value = {...shelves.value, book.id: shelf};
  }

  List<Book> booksOnShelf(Shelf shelf) {
    return shelves.value.entries
        .where((e) => e.value == shelf)
        .map((e) => _shelfBooks[e.key])
        .whereType<Book>()
        .toList();
  }
}