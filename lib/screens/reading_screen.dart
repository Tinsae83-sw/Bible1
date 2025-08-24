// screens/reading_screen.dart
import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import '../services/database_service.dart';
import '../services/settings_service.dart';
import '../models/bible_book.dart';
import '../models/bible_chapter.dart';
import '../widgets/bible_verse_tile.dart';

class ReadingScreen extends StatefulWidget {
  final BibleBook book;
  final int chapterNumber;

  const ReadingScreen(
      {super.key, required this.book, required this.chapterNumber});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final BibleService _bibleService = BibleService();
  final DatabaseService _databaseService = DatabaseService();
  final SettingsService _settingsService = SettingsService();
  BibleChapter? _chapter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChapter();
    _saveReadingProgress();
  }

  Future<void> _loadChapter() async {
    try {
      final chapter =
          await _bibleService.getChapter(widget.book.id, widget.chapterNumber);
      setState(() {
        _chapter = chapter;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load chapter')),
      );
    }
  }

  Future<void> _saveReadingProgress() async {
    final preferences = await _databaseService.getUserPreferences();
    await _databaseService.saveUserPreferences(
      preferences.copyWith(
        lastReadBook: widget.book.id.toString(),
        lastReadChapter: widget.chapterNumber,
        lastReadVerse: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.amharicName} ${widget.chapterNumber}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: widget.chapterNumber > 1
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(
                          book: widget.book,
                          chapterNumber: widget.chapterNumber - 1,
                        ),
                      ),
                    );
                  }
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: widget.chapterNumber < widget.book.chapters
                ? () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadingScreen(
                          book: widget.book,
                          chapterNumber: widget.chapterNumber + 1,
                        ),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _chapter == null
              ? const Center(child: Text('Chapter not found'))
              : ValueListenableBuilder<String>(
                  valueListenable: _settingsService.fontFamilyNotifier,
                  builder: (context, fontFamily, child) {
                    return ValueListenableBuilder<double>(
                      valueListenable: _settingsService.fontSizeNotifier,
                      builder: (context, fontSize, child) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _chapter!.verses.length,
                          itemBuilder: (context, index) {
                            final verse = _chapter!.verses[index];
                            return BibleVerseTile(
                              verse: verse,
                              fontFamily: fontFamily,
                              fontSize: fontSize,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
