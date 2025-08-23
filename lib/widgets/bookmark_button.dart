// widgets/bookmark_button.dart
import 'package:flutter/material.dart';
import '../models/bible_verse.dart';
import '../services/database_service.dart';

class BookmarkButton extends StatefulWidget {
  final BibleVerse verse;

  const BookmarkButton({super.key, required this.verse});

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  final DatabaseService _databaseService = DatabaseService();
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final isBookmarked = await _databaseService.isBookmarked(widget.verse);
    setState(() {
      _isBookmarked = isBookmarked;
    });
  }

  void _toggleBookmark() async {
    if (_isBookmarked) {
      await _databaseService.removeBookmark(widget.verse);
    } else {
      await _databaseService.saveBookmark(widget.verse);
    }

    setState(() {
      _isBookmarked = !_isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: _isBookmarked ? Theme.of(context).colorScheme.primary : null,
      ),
      onPressed: _toggleBookmark,
    );
  }
}
