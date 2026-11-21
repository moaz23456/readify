import 'package:readify/core/models/book.dart';

class DiscoverRepository {
  /// TODO(API): هنغير الدالة دي بس لما اللينك يجهز.
  /// الـ endpoint: GET /api/v1/Books  (فيه page و pageSize)
  Future<List<Book>> getPopularBooks() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return List.generate(
      30,
          (i) => Book(
        id: '${i + 1}',
        title: 'Book ${i + 1}',
        author: 'Author ${i + 1}',
      ),
    );
  }
}