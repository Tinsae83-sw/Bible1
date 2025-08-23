// widgets/bible_verse_tile.dart
import 'package:flutter/material.dart';
import '../models/bible_verse.dart';

class BibleVerseTile extends StatelessWidget {
  final BibleVerse verse;
  final String? highlightText;
  final Function()? onBookmark;
  final Function()? onHighlight;
  final Function()? onShare;

  const BibleVerseTile({
    super.key,
    required this.verse,
    this.highlightText,
    this.onBookmark,
    this.onHighlight,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      elevation: 1.0,
      color: verse.isHighlighted
          ? _getHighlightColor(verse.highlightColor)
          : Colors.white,
      child: ListTile(
        title: highlightText != null && highlightText!.isNotEmpty
            ? _buildHighlightedText(verse.text, highlightText!)
            : Text(
                verse.text,
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle:
                      verse.isHighlighted ? FontStyle.italic : FontStyle.normal,
                ),
              ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '${verse.bookName} ${verse.chapterNumber}:${verse.verseNumber}',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                      ? Icons.format_color_fill
                      : Icons.format_color_text,
                  color: verse.isHighlighted
                      ? _getHighlightIconColor(verse.highlightColor)
                      : Colors.grey,
                ),
                onPressed: onHighlight,
                tooltip: verse.isHighlighted
                    ? 'Remove highlight'
                    : 'Highlight verse',
              ),
            if (onShare != null)
              IconButton(
                icon: const Icon(Icons.share, color: Colors.grey),
                onPressed: onShare,
                tooltip: 'Share verse',
              ),
          ],
        ),
        onTap: () {
          // Navigate to the reading screen for this verse
          // You'll need to implement this navigation
        },
      ),
    );
  }

  Color _getHighlightColor(String? colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow.withOpacity(0.3);
      case 'blue':
        return Colors.blue.withOpacity(0.3);
      case 'green':
        return Colors.green.withOpacity(0.3);
      case 'pink':
        return Colors.pink.withOpacity(0.3);
      case 'orange':
        return Colors.orange.withOpacity(0.3);
      default:
        return Colors.yellow.withOpacity(0.3); // Default highlight color
    }
  }

  Color _getHighlightIconColor(String? colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow[700]!;
      case 'blue':
        return Colors.blue[700]!;
      case 'green':
        return Colors.green[700]!;
      case 'pink':
        return Colors.pink[700]!;
      case 'orange':
        return Colors.orange[700]!;
      default:
        return Colors.yellow[700]!; // Default highlight icon color
    }
  }

  Widget _buildHighlightedText(String text, String highlight) {
    final textLower = text.toLowerCase();
    final highlightLower = highlight.toLowerCase();
    final List<TextSpan> spans = [];
    int start = 0;
    int indexOfHighlight;

    while (
        (indexOfHighlight = textLower.indexOf(highlightLower, start)) != -1) {
      // Add non-highlighted text
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            fontStyle:
                verse.isHighlighted ? FontStyle.italic : FontStyle.normal,
          ),
        ));
      }

      // Add highlighted text
      final endIndex = indexOfHighlight + highlight.length;
      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, endIndex),
        style: TextStyle(
          color: Colors.white,
          backgroundColor: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          fontStyle: verse.isHighlighted ? FontStyle.italic : FontStyle.normal,
        ),
      ));

      start = endIndex;
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
          fontStyle: verse.isHighlighted ? FontStyle.italic : FontStyle.normal,
        ),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }
}
