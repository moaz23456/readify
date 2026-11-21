class Book {
  final String id;
  final String title;
  final String author;
  final String coverUrl;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl = '',
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverUrl: json['cover_url'] ?? '',
    );
  }
}