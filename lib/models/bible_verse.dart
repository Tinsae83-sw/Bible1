// models/bible_verse.dart
class BibleVerse {
  final int bookId;
  final String bookName;
  final int chapterNumber;
  final int verseNumber;
  final String text;
  final bool isBookmarked;
  final bool isHighlighted;
  final String? highlightColor;

  BibleVerse({
    required this.bookId,
    required this.bookName,
    required this.chapterNumber,
    required this.verseNumber,
    required this.text,
    this.isBookmarked = false,
    this.isHighlighted = false,
    this.highlightColor,
  });

  factory BibleVerse.fromJson(Map<String, dynamic> json) {
    return BibleVerse(
      bookId: json['bookId'],
      bookName: json['bookName'],
      chapterNumber: json['chapterNumber'],
      verseNumber: json['verseNumber'],
      text: json['text'],
      isBookmarked: json['isBookmarked'] ?? false,
      isHighlighted: json['isHighlighted'] ?? false,
      highlightColor: json['highlightColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'chapterNumber': chapterNumber,
      'verseNumber': verseNumber,
      'text': text,
      'isBookmarked': isBookmarked,
      'isHighlighted': isHighlighted,
      'highlightColor': highlightColor,
    };
  }
}
