import 'package:flutter/material.dart';
import '../models/bible_verse.dart';
import '../services/database_service.dart';

class VerseHighlightButton extends StatefulWidget {
  final BibleVerse verse;
  final DatabaseService databaseService;

  const VerseHighlightButton({
    super.key,
    required this.verse,
    required this.databaseService,
  });

  @override
  State<VerseHighlightButton> createState() => _VerseHighlightButtonState();
}

class _VerseHighlightButtonState extends State<VerseHighlightButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        widget.verse.isHighlighted ? Icons.highlight : Icons.highlight_outlined,
        color: widget.verse.isHighlighted
            ? _getColorFromString(widget.verse.highlightColor)
            : null,
      ),
      onPressed: () {
        // This will be handled by the parent widget through the onHighlight callback
      },
    );
  }

  Color _getColorFromString(String? colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.yellow;
    }
  }
}
