class Article {
  final String id;
  final String title;
  final String content;
  final String category; // "INFO" atau "EDUKASI"
  final String imageUrl;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
  });

  Article copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
