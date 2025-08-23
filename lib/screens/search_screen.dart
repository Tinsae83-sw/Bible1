// screens/search_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import '../models/bible_verse.dart';
import '../widgets/bible_verse_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BibleService _bibleService = BibleService();
  final TextEditingController _searchController = TextEditingController();
  List<BibleVerse> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await _bibleService.searchVerses(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      print('Search error: $e');
    }
  }

  void _onSearchChanged(String query) {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Set a new timer to debounce the search
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  void _toggleBookmark(BibleVerse verse) {
    setState(() {
      verse.isBookmarked = !verse.isBookmarked;
      // Save the bookmark state to your database or shared preferences
    });
  }

  void _toggleHighlight(BibleVerse verse) {
    setState(() {
      verse.isHighlighted = !verse.isHighlighted;
      verse.highlightColor = verse.isHighlighted ? 'yellow' : null;
      // Save the highlight state to your database or shared preferences
    });
  }

  void _shareVerse(BibleVerse verse) {
    // Implement share functionality
    final String shareText =
        '${verse.bookName} ${verse.chapterNumber}:${verse.verseNumber}\n${verse.text}';
    print('Sharing verse: $shareText');
    // Use the share package or platform-specific sharing code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Bible'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for words or sentences...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults = [];
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 14.0,
                ),
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _performSearch,
            ),
          ),
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Enter words or sentences to search'
                              : _isSearching
                                  ? 'Searching...'
                                  : 'No results found for "${_searchController.text}"',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final verse = _searchResults[index];
                      final searchText = _searchController.text.toLowerCase();

                      return BibleVerseTile(
                        verse: verse,
                        highlightText: searchText,
                        onBookmark: () => _toggleBookmark(verse),
                        onHighlight: () => _toggleHighlight(verse),
                        onShare: () => _shareVerse(verse),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
