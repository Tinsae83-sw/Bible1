import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import '../models/bible_verse.dart';
import '../widgets/bible_verse_title.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final BibleService _bibleService = BibleService();
  final TextEditingController _searchController = TextEditingController();
  List<BibleVerse> _searchResults = [];
  bool _isSearching = false;

  void _searchVerses(String query) async {
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
        _isSearching = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('የፍለጋ ስህተት: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ፍለጋ'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'መጽሐፍ ቅዱስ ፍለጋ...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _searchVerses(_searchController.text),
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _searchVerses,
            ),
          ),
          _isSearching
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: _searchResults.isEmpty
                      ? Center(
                          child: Text(
                            _searchController.text.isEmpty
                                ? 'ፍለጋ የሚፈልጉትን ጥቅስ ይፃፉ'
                                : 'ምንም ውጤት አልተገኘም',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final verse = _searchResults[index];
                            return BibleVerseTile(
                              verse: verse,
                              highlightText: _searchController.text,
                              fontFamily: 'AbyssinicaSIL',
                              fontSize: 16.0,
                            );
                          },
                        ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
