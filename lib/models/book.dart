class Book {
  final String id;
  final String title;
  final String isbn;
  final String categoryId;
  final String categoryName;
  final String authorId;
  final String authorName;
  final String publisherId;
  final String publisherName;
  final String description;
  final String? coverImageUrl;
  final int totalCopies;
  final int availableCopies;

  const Book({
    required this.id,
    required this.title,
    required this.isbn,
    required this.categoryId,
    required this.categoryName,
    required this.authorId,
    required this.authorName,
    required this.publisherId,
    required this.publisherName,
    required this.description,
    this.coverImageUrl,
    required this.totalCopies,
    required this.availableCopies,
  });

  bool get isAvailable => availableCopies > 0;

  Book copyWith({
    String? id,
    String? title,
    String? isbn,
    String? categoryId,
    String? categoryName,
    String? authorId,
    String? authorName,
    String? publisherId,
    String? publisherName,
    String? description,
    String? coverImageUrl,
    int? totalCopies,
    int? availableCopies,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      isbn: isbn ?? this.isbn,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      publisherId: publisherId ?? this.publisherId,
      publisherName: publisherName ?? this.publisherName,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      totalCopies: totalCopies ?? this.totalCopies,
      availableCopies: availableCopies ?? this.availableCopies,
    );
  }
}
