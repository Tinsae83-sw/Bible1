import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/bible_service.dart';
import '../services/database_service.dart';
import '../services/settings_service.dart';
import '../models/bible_book.dart';
import '../models/bible_chapter.dart';
import '../models/bible_verse.dart';
import '../widgets/bible_verse_title.dart';

class ReadingScreen extends StatefulWidget {
  final BibleBook book;
  final int chapterNumber;

  const ReadingScreen({
    super.key,
    required this.book,
    required this.chapterNumber,
  });

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

      // Load verse states after chapter is loaded
      _loadVerseStates();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ክፍሉ መጫን አልተቻለም')),
      );
    }
  }

  Future<void> _loadVerseStates() async {
    if (_chapter == null) return;

    for (var verse in _chapter!.verses) {
      // Check if verse is bookmarked
      final isBookmarked = await _databaseService.isBookmarked(verse);

      // Check if verse has highlight
      final highlightData = await _databaseService.getHighlight(verse);

      setState(() {
        verse.isBookmarked = isBookmarked;
        if (highlightData != null) {
          verse.isHighlighted = true;
          verse.highlightColor = highlightData['color'];
        }
      });
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

  void _navigateToChapter(int chapterNumber) {
    if (chapterNumber >= 1 && chapterNumber <= widget.book.chapters) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReadingScreen(
            book: widget.book,
            chapterNumber: chapterNumber,
          ),
        ),
      );
    }
  }

  void _showHighlightColorDialog(BibleVerse verse) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'የጎልማሳ ቀለም ምረጥ',
            style: TextStyle(fontFamily: 'NotoSansEthiopic'),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.yellow),
                  title: Text('ቢጫ',
                      style: TextStyle(fontFamily: 'NotoSansEthiopic')),
                  onTap: () => _applyHighlight(verse, 'yellow'),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.green),
                  title: Text('አረንጓዴ',
                      style: TextStyle(fontFamily: 'NotoSansEthiopic')),
                  onTap: () => _applyHighlight(verse, 'green'),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.blue),
                  title: Text('ሰማያዊ',
                      style: TextStyle(fontFamily: 'NotoSansEthiopic')),
                  onTap: () => _applyHighlight(verse, 'blue'),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.pink),
                  title: Text('ሮዝ',
                      style: TextStyle(fontFamily: 'NotoSansEthiopic')),
                  onTap: () => _applyHighlight(verse, 'pink'),
                ),
                ListTile(
                  leading: Icon(Icons.color_lens, color: Colors.purple),
                  title: Text('ሐምራዊ',
                      style: TextStyle(fontFamily: 'NotoSansEthiopic')),
                  onTap: () => _applyHighlight(verse, 'purple'),
                ),
                if (verse.isHighlighted)
                  ListTile(
                    leading: Icon(Icons.highlight_off, color: Colors.red),
                    title: Text('ጎልማሳ አስወግድ',
                        style: TextStyle(fontFamily: 'NotoSansEthiopic')),
                    onTap: () => _removeHighlight(verse),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _applyHighlight(BibleVerse verse, String color) {
    setState(() {
      verse.isHighlighted = true;
      verse.highlightColor = color;
    });
    _databaseService.updateHighlight(verse, color);
    Navigator.pop(context);
  }

  void _removeHighlight(BibleVerse verse) {
    setState(() {
      verse.isHighlighted = false;
      verse.highlightColor = null;
    });
    _databaseService.removeHighlight(verse);
    Navigator.pop(context);
  }

  void _shareVerse(BibleVerse verse) {
    final String shareText =
        '${verse.bookName} ${verse.chapterNumber}:${verse.verseNumber}\n${verse.amharicText}';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('አጋራ', style: TextStyle(fontFamily: 'NotoSansEthiopic')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${verse.bookName} ${verse.chapterNumber}:${verse.verseNumber}',
                style: TextStyle(
                  fontFamily: 'NotoSansEthiopic',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              SelectableText(
                verse.amharicText,
                style: TextStyle(fontFamily: 'NotoSansEthiopic'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: shareText));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ወደ አሻገር ተቀዳጅቷል!')),
                );
                Navigator.pop(context);
              },
              child: Text('አሻገር ላይ ለጥፍ እና ዝጋ',
                  style: TextStyle(fontFamily: 'NotoSansEthiopic')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.book.amharicName} ምዕራፍ ${widget.chapterNumber}',
          style: TextStyle(
            fontFamily: 'NotoSansEthiopic',
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: widget.chapterNumber > 1
                ? () => _navigateToChapter(widget.chapterNumber - 1)
                : null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '${widget.chapterNumber}/${widget.book.chapters}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'NotoSansEthiopic',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: widget.chapterNumber < widget.book.chapters
                ? () => _navigateToChapter(widget.chapterNumber + 1)
                : null,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _chapter == null
              ? Center(
                  child: Text(
                    'ክፍሉ አልተገኘም',
                    style: TextStyle(
                      fontFamily: 'NotoSansEthiopic',
                      fontSize: 18,
                    ),
                  ),
                )
              : ValueListenableBuilder<String>(
                  valueListenable: _settingsService.fontFamilyNotifier,
                  builder: (context, fontFamily, child) {
                    return ValueListenableBuilder<double>(
                      valueListenable: _settingsService.fontSizeNotifier,
                      builder: (context, fontSize, child) {
                        return ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: _chapter!.verses.length,
                          itemBuilder: (context, index) {
                            final verse = _chapter!.verses[index];
                            return BibleVerseTile(
                              verse: verse,
                              fontFamily: fontFamily.isNotEmpty
                                  ? fontFamily
                                  : 'NotoSansEthiopic',
                              fontSize: fontSize,
                              onBookmark: () {
                                setState(() {
                                  verse.isBookmarked = !verse.isBookmarked;
                                });
                                _databaseService.toggleBookmark(verse);
                              },
                              onHighlight: () {
                                _showHighlightColorDialog(verse);
                              },
                              onShare: () {
                                _shareVerse(verse);
                              },
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
