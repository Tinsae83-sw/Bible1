import 'package:flutter/material.dart';
import '../models/bible_verse.dart';

class BibleVerseTile extends StatelessWidget {
  final BibleVerse verse;
  final String fontFamily;
  final double fontSize;
  final VoidCallback onBookmark;
  final VoidCallback onHighlight;
  final VoidCallback onShare;

  const BibleVerseTile({
    super.key,
    required this.verse,
    required this.fontFamily,
    required this.fontSize,
    required this.onBookmark,
    required this.onHighlight,
    required this.onShare,
  });

  Color _getHighlightColor(String? colorName) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: verse.isHighlighted
            ? _getHighlightColor(verse.highlightColor)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Verse number
          Container(
            width: 30,
            alignment: Alignment.topCenter,
            child: Text(
              '${verse.verseNumber}.',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize * 0.9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          // Verse text
          Expanded(
            child: Text(
              verse.amharicText,
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          // Three-dot menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 20),
            onSelected: (value) {
              if (value == 'bookmark') {
                onBookmark();
              } else if (value == 'highlight') {
                onHighlight();
              } else if (value == 'share') {
                onShare();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'bookmark',
                child: Row(
                  children: [
                    Icon(
                      verse.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 8),
                    Text(
                      verse.isBookmarked ? 'መጽሐፍ ምልክት አስወግድ' : 'መጽሐፍ ምልክት አድርግ',
                      style: TextStyle(
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'highlight',
                child: Row(
                  children: [
                    Icon(
                      Icons.highlight,
                      color: Colors.amber,
                    ),
                    SizedBox(width: 8),
                    Text(
                      verse.isHighlighted ? 'ጎልማሳ ቀይር' : 'ጎልማሳ',
                      style: TextStyle(
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'አጋራ',
                      style: TextStyle(
                        fontFamily: 'NotoSansEthiopic',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
