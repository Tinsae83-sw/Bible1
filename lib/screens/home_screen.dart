import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/navigation_drawer.dart';

class Verse {
  final int verse;
  final String text;

  Verse({required this.verse, required this.text});

  factory Verse.fromJson(int verseNumber, String text) {
    return Verse(
      verse: verseNumber,
      text: text,
    );
  }
}

class Chapter {
  final int chapter;
  final List<Verse> verses;

  Chapter({required this.chapter, required this.verses});
}

class BookContent {
  final int bookId;
  final String bookName;
  final List<Chapter> chapters;

  BookContent({
    required this.bookId,
    required this.bookName,
    required this.chapters,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _showSearch = false;
  String _selectedLanguage = 'English';
  BookContent? _genesisContent;
  int _currentChapter = 1;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadGenesis();
  }

  Future<void> _loadGenesis() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/bible_data/genesis.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse the JSON with the correct structure
      final genesisData = jsonData['genesis'];
      List<Chapter> chapters = [];

      genesisData.forEach((chapterKey, versesData) {
        // Extract chapter number from key (e.g., "Chapter 1" -> 1)
        final chapterNumber = int.parse(chapterKey.split(' ')[1]);

        List<Verse> verses = [];
        (versesData as Map<String, dynamic>).forEach((verseNumber, text) {
          verses.add(Verse.fromJson(int.parse(verseNumber), text));
        });

        // Sort verses by verse number
        verses.sort((a, b) => a.verse.compareTo(b.verse));

        chapters.add(Chapter(chapter: chapterNumber, verses: verses));
      });

      // Sort chapters by chapter number
      chapters.sort((a, b) => a.chapter.compareTo(b.chapter));

      setState(() {
        _genesisContent = BookContent(
          bookId: 1,
          bookName: 'Genesis',
          chapters: chapters,
        );
        _isLoading = false;
        _errorMessage = '';
      });
    } catch (e) {
      print('Error loading Genesis: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load Genesis: $e';
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _changeChapter(int chapter) {
    setState(() {
      _currentChapter = chapter;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search verses...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
              )
            : Text('Genesis'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Open navigation menu',
          ),
        ),
        actions: [
          if (!_showSearch)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _toggleSearch,
              tooltip: 'Search verses',
            ),
          if (_showSearch)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: _toggleSearch,
              tooltip: 'Close search',
            ),
          PopupMenuButton<String>(
            onSelected: _changeLanguage,
            itemBuilder: (BuildContext context) {
              return {'English', 'Amharic'}.map((String language) {
                return PopupMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.language, color: Colors.white),
            ),
          ),
          // Added the new PopupMenuButton for Settings and About
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'settings') {
                // Navigate to settings screen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              } else if (value == 'about') {
                // Navigate to about screen
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: 'about',
                child: Text('About'),
              ),
            ],
            icon: Icon(Icons.more_vert, color: Colors.white),
            offset: Offset(0, 50), // Adjust menu position if needed
          ),
        ],
      ),
      drawer: BibleNavigationDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _genesisContent == null || _genesisContent!.chapters.isEmpty
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage.isNotEmpty
                              ? _errorMessage
                              : 'Failed to load Genesis content',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadGenesis,
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Chapter selector
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.grey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: _currentChapter > 1
                                ? () => _changeChapter(_currentChapter - 1)
                                : null,
                          ),
                          Text('Chapter $_currentChapter'),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _currentChapter <
                                    _genesisContent!.chapters.length
                                ? () => _changeChapter(_currentChapter + 1)
                                : null,
                          ),
                        ],
                      ),
                    ),
                    // Bible text
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _genesisContent!
                            .chapters[_currentChapter - 1].verses.length,
                        itemBuilder: (context, index) {
                          final verse = _genesisContent!
                              .chapters[_currentChapter - 1].verses[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${verse.verse} ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                  TextSpan(text: verse.text),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
