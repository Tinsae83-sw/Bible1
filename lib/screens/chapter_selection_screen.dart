import 'package:flutter/material.dart';
import 'package:holy_bible/services/bible_service.dart';
import 'package:holy_bible/models/bible_book.dart';
import 'package:holy_bible/screens/reading_screen.dart';

class ChapterSelectionScreen extends StatefulWidget {
  final BibleBook? initialBook;

  ChapterSelectionScreen({this.initialBook});

  @override
  State<ChapterSelectionScreen> createState() => _ChapterSelectionScreenState();
}

class _ChapterSelectionScreenState extends State<ChapterSelectionScreen> {
  final BibleService _bibleService = BibleService();
  BibleBook? _selectedBook;
  bool _isLoading = true;
  bool _showAmharicNumbers = true; // Toggle between Amharic and Arabic numbers

  @override
  void initState() {
    super.initState();
    _selectedBook = widget.initialBook;
    _isLoading = false;
  }

  void _navigateToChapter(int chapterNumber) {
    if (_selectedBook != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReadingScreen(
            book: _selectedBook!,
            chapterNumber: chapterNumber,
          ),
        ),
      );
    }
  }

  void _toggleNumberFormat() {
    setState(() {
      _showAmharicNumbers = !_showAmharicNumbers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedBook != null
            ? "${_selectedBook!.name} - Chapters"
            : "Select Chapter"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showAmharicNumbers ? Icons.language : Icons.numbers),
            onPressed: _toggleNumberFormat,
            tooltip: _showAmharicNumbers
                ? 'Show Arabic numbers'
                : 'Show Amharic numbers',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _selectedBook != null
              ? _buildChaptersGrid(context)
              : const Center(child: Text("No book selected")),
    );
  }

  Widget _buildChaptersGrid(BuildContext context) {
    // Amharic numbers from 1 to 50
    List<String> amharicNumbers = [
      "፩",
      "፪",
      "፫",
      "፬",
      "፭",
      "፮",
      "፯",
      "፰",
      "፱",
      "፲",
      "፲፩",
      "፲፪",
      "፲፫",
      "፲፬",
      "፲፭",
      "፲፮",
      "፲፯",
      "፲፰",
      "፲፱",
      "፳",
      "፳፩",
      "፳፪",
      "፳፫",
      "፳፬",
      "፳፭",
      "፳፮",
      "፳፯",
      "፳፰",
      "፳፱",
      "፴",
      "፴፩",
      "፴፪",
      "፴፫",
      "፴፬",
      "፴፭",
      "፴፮",
      "፴፯",
      "፴፰",
      "፴፱",
      "፵",
      "፵፩",
      "፵፪",
      "፵፫",
      "፵፬",
      "፵፭",
      "፵፮",
      "፵፯",
      "፵፰",
      "፵፱",
      "፶"
    ];

    // Calculate responsive values based on screen size
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine number of columns based on screen width
    int crossAxisCount;
    if (screenWidth < 320) {
      // Very small phones
      crossAxisCount = 4;
    } else if (screenWidth < 400) {
      // Small phones
      crossAxisCount = 5;
    } else if (screenWidth < 480) {
      // Medium phones
      crossAxisCount = 6;
    } else {
      // Large phones
      crossAxisCount = 7;
    }

    // Adjust spacing based on screen size
    final spacing = screenWidth < 320 ? 6.0 : 8.0;
    final padding = screenWidth < 320 ? 8.0 : 16.0;

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 1.0,
      ),
      itemCount: _selectedBook!.chapters,
      itemBuilder: (context, index) {
        final chapterNumber = index + 1;

        // Determine which number format to show
        final displayNumber =
            _showAmharicNumbers && chapterNumber <= amharicNumbers.length
                ? amharicNumbers[chapterNumber - 1]
                : chapterNumber.toString();

        return ChapterGridItem(
          displayNumber: displayNumber,
          onTap: () => _navigateToChapter(chapterNumber),
          screenWidth: screenWidth,
        );
      },
    );
  }
}

class ChapterGridItem extends StatelessWidget {
  final String displayNumber;
  final VoidCallback onTap;
  final double screenWidth;

  const ChapterGridItem({
    required this.displayNumber,
    required this.onTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate responsive font size based on screen width
    final fontSize = screenWidth < 320
        ? 20.0
        : screenWidth < 400
            ? 22.0
            : screenWidth < 480
                ? 24.0
                : 26.0;

    return Container(
      margin: EdgeInsets.all(screenWidth < 320 ? 2.0 : 4.0),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Text(
                displayNumber,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
