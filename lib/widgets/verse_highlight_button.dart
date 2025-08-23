// widgets/verse_highlight_button.dart
import 'package:flutter/material.dart';
import '../models/bible_verse.dart';

class VerseHighlightButton extends StatefulWidget {
  final BibleVerse verse;

  const VerseHighlightButton({super.key, required this.verse});

  @override
  State<VerseHighlightButton> createState() => _VerseHighlightButtonState();
}

class _VerseHighlightButtonState extends State<VerseHighlightButton> {
  bool _isHighlighted = false;
  String? _highlightColor;

  @override
  void initState() {
    super.initState();
    _isHighlighted = widget.verse.isHighlighted;
    _highlightColor = widget.verse.highlightColor;
  }

  void _toggleHighlight() {
    setState(() {
      _isHighlighted = !_isHighlighted;
      if (!_isHighlighted) {
        _highlightColor = null;
      } else {
        _highlightColor = 'yellow'; // Default highlight color
      }
    });

    // Save highlight state to database
    // This would typically call a method in DatabaseService
  }

  void _changeHighlightColor(String color) {
    setState(() {
      _highlightColor = color;
    });

    // Save highlight color to database
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'yellow',
          child: Row(
            children: [
              Icon(Icons.lens, color: Colors.yellow),
              const SizedBox(width: 8),
              const Text('Yellow'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'green',
          child: Row(
            children: [
              Icon(Icons.lens, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Green'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'blue',
          child: Row(
            children: [
              Icon(Icons.lens, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('Blue'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'pink',
          child: Row(
            children: [
              Icon(Icons.lens, color: Colors.pink),
              const SizedBox(width: 8),
              const Text('Pink'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'remove',
          child: Row(
            children: [
              const Icon(Icons.highlight_off),
              const SizedBox(width: 8),
              const Text('Remove Highlight'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        if (value == 'remove') {
          _toggleHighlight();
        } else {
          _changeHighlightColor(value);
        }
      },
      child: IconButton(
        icon: Icon(
          _isHighlighted ? Icons.highlight : Icons.highlight_outlined,
          color: _highlightColor != null
              ? _getColorFromString(_highlightColor!)
              : Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: _toggleHighlight,
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'pink':
        return Colors.pink;
      default:
        return Colors.yellow;
    }
  }
}
