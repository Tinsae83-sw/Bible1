// widgets/bible_verse_tile.dart
import 'package:flutter/material.dart';
import '../models/bible_verse.dart';

class BibleVerseTile extends StatelessWidget {
  final BibleVerse verse;
  final String? highlightText;
  final VoidCallback? onBookmark;
  final VoidCallback? onHighlight;
  final VoidCallback? onShare;
  final String fontFamily;
  final double fontSize;

  BibleVerseTile({
    required this.verse,
    this.highlightText,
    this.onBookmark,
    this.onHighlight,
    this.onShare,
    required this.fontFamily,
    required this.fontSize,
  });

  Color _getHighlightColor(String colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow.withOpacity(0.3);
      case 'green':
        return Colors.green.withOpacity(0.3);
      case 'blue':
        return Colors.blue.withOpacity(0.3);
      case 'pink':
        return Colors.pink.withOpacity(0.3);
      case 'purple':
        return Colors.purple.withOpacity(0.3);
      default:
        return Colors.yellow.withOpacity(0.3);
    }
  }

  Color _getHighlightIconColor(String colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  // Helper method to highlight text matches
  TextSpan _buildHighlightedText(String text, String? query) {
    if (query == null || query.isEmpty) {
      return TextSpan(text: text);
    }

    final pattern = RegExp(query, caseSensitive: false);
    final matches = pattern.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(text: text);
    }

    final List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, match.start),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          backgroundColor: Colors.yellow,
          fontWeight: FontWeight.bold,
        ),
      ));

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
      ));
    }

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: verse.isHighlighted
            ? _getHighlightColor(verse.highlightColor ?? 'yellow')
            : null,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${verse.bookName} ${verse.chapterNumber}:${verse.verseNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: fontFamily,
                  fontStyle:
                      verse.isHighlighted ? FontStyle.italic : FontStyle.normal,
                ),
              ),
              Spacer(),
              if (onBookmark != null)
                IconButton(
                  icon: Icon(
                    verse.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: verse.isBookmarked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: onBookmark,
                  tooltip:
                      verse.isBookmarked ? 'Remove bookmark' : 'Add bookmark',
                ),
              if (onHighlight != null)
                IconButton(
                  icon: Icon(
                    verse.isHighlighted
                        ? Icons.color_lens
                        : Icons.color_lens_outlined,
                    color: verse.isHighlighted
                        ? _getHighlightIconColor(
                            verse.highlightColor ?? 'yellow')
                        : Colors.grey,
                  ),
                  onPressed: onHighlight,
                  tooltip: verse.isHighlighted
                      ? 'Remove highlight'
                      : 'Add highlight',
                ),
              if (onShare != null)
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: onShare,
                  tooltip: 'Share verse',
                ),
            ],
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: fontFamily,
                color: Colors.black,
                fontStyle:
                    verse.isHighlighted ? FontStyle.italic : FontStyle.normal,
              ),
              children: [
                _buildHighlightedText(verse.text, highlightText),
              ],
            ),
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: fontFamily,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
              children: [
                _buildHighlightedText(verse.amharicText, highlightText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
