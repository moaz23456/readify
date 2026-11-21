import 'package:readify/core/models/book.dart';

enum FeedAction { rated, reading }

class FeedItem {
  final String userName;
  final FeedAction action;
  final int rating;
  final String timeAgo;
  final Book book;

  const FeedItem({
    required this.userName,
    required this.action,
    this.rating = 0,
    required this.timeAgo,
    required this.book,
  });

  factory FeedItem.fromJson(Map<String, dynamic> json) {
    return FeedItem(
      userName: json['user_name'] ?? '',
      action: json['action'] == 'reading'
          ? FeedAction.reading
          : FeedAction.rated,
      rating: json['rating'] ?? 0,
      timeAgo: json['time_ago'] ?? '',
      book: Book.fromJson(json['book']),
    );
  }
}

class HomeRepository {
  /// TODO(API): هنغير الدالة دي بس لما اللينك يجهز.
  Future<List<FeedItem>> getFeed() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      FeedItem(
        userName: 'Odd',
        action: FeedAction.rated,
        rating: 4,
        timeAgo: '1 hour ago',
        book: Book(
          id: '1',
          title: 'Zikola land',
          author: 'Amr Abdel Hamid',
        ),
      ),
      FeedItem(
        userName: 'Odd',
        action: FeedAction.reading,
        timeAgo: '3 hours ago',
        book: Book(
          id: '2',
          title: 'The spell shop',
          author: 'Sarah Beth Durst',
        ),
      ),
      FeedItem(
        userName: 'Odd',
        action: FeedAction.reading,
        timeAgo: 'Yesterday',
        book: Book(
          id: '3',
          title: 'Zikola land 2',
          author: 'Amr Abdel Hamid',
        ),
      ),
    ];
  }
}