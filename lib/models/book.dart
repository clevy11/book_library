class Book {
  final int? id;
  final String title;
  final String author;
  final double rating;
  final bool isRead;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.rating,
    required this.isRead,
  });

  Book copyWith({
    int? id,
    String? title,
    String? author,
    double? rating,
    bool? isRead,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      rating: rating ?? this.rating,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'rating': rating,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      rating: map['rating'],
      isRead: map['isRead'] == 1,
    );
  }
}
