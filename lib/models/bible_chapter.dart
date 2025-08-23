// models/bible_chapter.dart
import 'bible_verse.dart';

class BibleChapter {
  final int bookId;
  final int chapterNumber;
  final List<BibleVerse> verses;

  BibleChapter({
    required this.bookId,
    required this.chapterNumber,
    required this.verses,
  });
}
