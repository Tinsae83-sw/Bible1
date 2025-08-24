// services/bible_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:holy_bible/models/bible_book.dart';
import 'package:holy_bible/models/bible_chapter.dart';
import 'package:holy_bible/models/bible_verse.dart';

class BibleService {
  static final BibleService _instance = BibleService._internal();
  factory BibleService() => _instance;
  BibleService._internal();

  List<BibleBook>? _books;

  // Map to convert book names to file names
  final Map<String, String> _bookFileMap = {
    'Genesis': 'genesis',
    'Exodus': 'exodus',
    'Leviticus': 'leviticus',
    'Numbers': 'numbers',
    'Deuteronomy': 'deuteronomy',
    'Joshua': 'joshua',
    'Judges': 'judges',
    'Ruth': 'ruth',
    '1 Samuel': '1samuel',
    '2 Samuel': '2samuel',
    '1 Kings': '1kings',
    '2 Kings': '2kings',
    '1 Chronicles': '1chronicles',
    '2 Chronicles': '2chronicles',
    'Ezra': 'ezra',
    'Nehemiah': 'nehemiah',
    'Esther': 'esther',
    'Job': 'job',
    'Psalms': 'psalms',
    'Proverbs': 'proverbs',
    'Ecclesiastes': 'ecclesiastes',
    'Song of Solomon': 'songofsolomon',
    'Isaiah': 'isaiah',
    'Jeremiah': 'jeremiah',
    'Lamentations': 'lamentations',
    'Ezekiel': 'ezekiel',
    'Daniel': 'daniel',
    'Hosea': 'hosea',
    'Joel': 'joel',
    'Amos': 'amos',
    'Obadiah': 'obadiah',
    'Jonah': 'jonah',
    'Micah': 'micah',
    'Nahum': 'nahum',
    'Habakkuk': 'habakkuk',
    'Zephaniah': 'zephaniah',
    'Haggai': 'haggai',
    'Zechariah': 'zechariah',
    'Malachi': 'malachi',
    'Matthew': 'matthew',
    'Mark': 'mark',
    'Luke': 'luke',
    'John': 'john',
    'Acts': 'acts',
    'Romans': 'romans',
    '1 Corinthians': '1corinthians',
    '2 Corinthians': '2corinthians',
    'Galatians': 'galatians',
    'Ephesians': 'ephesians',
    'Philippians': 'philippians',
    'Colossians': 'colossians',
    '1 Thessalonians': '1thessalonians',
    '2 Thessalonians': '2thessalonians',
    '1 Timothy': '1timothy',
    '2 Timothy': '2timothy',
    'Titus': 'titus',
    'Philemon': 'philemon',
    'Hebrews': 'hebrews',
    'James': 'james',
    '1 Peter': '1peter',
    '2 Peter': '2peter',
    '1 John': '1john',
    '2 John': '2john',
    '3 John': '3john',
    'Jude': 'jude',
    'Revelation': 'revelation',
  };

  Future<List<BibleBook>> getBooks() async {
    if (_books != null) return _books!;

    try {
      String jsonString;

      if (kIsWeb) {
        // For web, use HTTP to load the asset
        final response =
            await http.get(Uri.parse('assets/books/bible_books.json'));
        if (response.statusCode == 200) {
          jsonString = response.body;
        } else {
          print('Failed to load books from web: ${response.statusCode}');
          throw Exception('Failed to load books JSON: ${response.statusCode}');
        }
      } else {
        // For mobile, use rootBundle
        jsonString =
            await rootBundle.loadString('assets/books/bible_books.json');
      }

      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> booksJson = jsonData['books'];

      _books =
          booksJson.map((bookJson) => BibleBook.fromJson(bookJson)).toList();
      return _books!;
    } catch (e) {
      print('Error loading books: $e');
      // Fallback to sample data if JSON loading fails
      _books = [
        BibleBook(
          id: 1,
          name: "Genesis",
          amharicName: "ኦሪት ዘፍጥረት",
          testament: "Old",
          chapters: 50,
          abbreviation: "Gen",
        ),
        BibleBook(
          id: 2,
          name: "Exodus",
          amharicName: "ኦሪት ዘጸአት",
          testament: "Old",
          chapters: 40,
          abbreviation: "Exo",
        ),
        BibleBook(
          id: 40,
          name: "Matthew",
          amharicName: "የማቴዎስ ወንጌል",
          testament: "New",
          chapters: 28,
          abbreviation: "Mat",
        ),
      ];
      return _books!;
    }
  }

  Future<BibleBook> getBookById(int id) async {
    final books = await getBooks();
    return books.firstWhere((book) => book.id == id);
  }

  Future<BibleChapter> getChapter(int bookId, int chapterNumber) async {
    try {
      final book = await getBookById(bookId);

      // Get the file name from the mapping
      final String fileName =
          _bookFileMap[book.name] ?? book.name.toLowerCase();
      String jsonString;

      if (kIsWeb) {
        // For web, use HTTP to load the asset
        final response =
            await http.get(Uri.parse('assets/bible_data/$fileName.json'));
        if (response.statusCode == 200) {
          jsonString = response.body;
        } else {
          print('Failed to load chapter from web: ${response.statusCode}');
          return _getSampleChapter(bookId, chapterNumber, book.name);
        }
      } else {
        // For mobile, use rootBundle
        jsonString =
            await rootBundle.loadString('assets/bible_data/$fileName.json');
      }

      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Get the book data from the JSON (e.g., "exodus")
      final String bookKey = fileName.toLowerCase();
      if (!jsonData.containsKey(bookKey)) {
        print('JSON does not contain key: $bookKey');
        return _getSampleChapter(bookId, chapterNumber, book.name);
      }

      final Map<String, dynamic> bookData = jsonData[bookKey];
      final String chapterKey = 'Chapter $chapterNumber';

      if (!bookData.containsKey(chapterKey)) {
        print('Chapter $chapterNumber not found in book $bookKey');
        return _getSampleChapter(bookId, chapterNumber, book.name);
      }

      final Map<String, dynamic> versesMap = bookData[chapterKey];

      // Convert the verses map to a list of BibleVerse objects
      List<BibleVerse> verses = [];
      versesMap.forEach((verseNum, verseText) {
        int verseNumber = int.tryParse(verseNum) ?? 0;
        if (verseNumber > 0) {
          verses.add(BibleVerse(
            bookId: bookId,
            bookName: book.name,
            chapterNumber: chapterNumber,
            verseNumber: verseNumber,
            text: verseText.toString(),
            amharicText: verseText.toString(), // Using same text for now
            isBookmarked: false,
            isHighlighted: false,
            highlightColor: null,
          ));
        }
      });

      // Sort verses by verse number
      verses.sort((a, b) => a.verseNumber.compareTo(b.verseNumber));

      return BibleChapter(
        bookId: bookId,
        chapterNumber: chapterNumber,
        verses: verses,
      );
    } catch (e) {
      print('Error loading chapter: $e');
      final book = await getBookById(bookId);
      return _getSampleChapter(bookId, chapterNumber, book.name);
    }
  }

  BibleChapter _getSampleChapter(
      int bookId, int chapterNumber, String bookName) {
    List<BibleVerse> verses = [];

    for (int i = 1; i <= 5; i++) {
      verses.add(BibleVerse(
        bookId: bookId,
        bookName: bookName,
        chapterNumber: chapterNumber,
        verseNumber: i,
        text:
            "This is a sample verse $i from $bookName chapter $chapterNumber.",
        amharicText: "ይህ የ$chapterNumber ምዕራፍ $i ነጥብ ነው።",
        isBookmarked: false,
        isHighlighted: false,
        highlightColor: null,
      ));
    }

    return BibleChapter(
      bookId: bookId,
      chapterNumber: chapterNumber,
      verses: verses,
    );
  }

  Future<List<BibleVerse>> searchVerses(String query) async {
    final books = await getBooks();
    List<BibleVerse> results = [];

    // Limit search to first 3 chapters of each book for performance
    for (var book in books) {
      for (int chapter = 1; chapter <= 3; chapter++) {
        try {
          final bibleChapter = await getChapter(book.id, chapter);
          for (var verse in bibleChapter.verses) {
            if (verse.text.toLowerCase().contains(query.toLowerCase())) {
              results.add(verse);
            }
          }
        } catch (e) {
          continue;
        }
      }
    }

    return results;
  }
}
