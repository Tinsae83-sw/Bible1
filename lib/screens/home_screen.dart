import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/navigation_drawer.dart'; // This imports BibleNavigationDrawer
import 'settings_screen.dart';

class Book {
  final int id;
  final String name;
  final String amharicName;
  final String testament;
  final int chapters;
  final String abbreviation;

  Book({
    required this.id,
    required this.name,
    required this.amharicName,
    required this.testament,
    required this.chapters,
    required this.abbreviation,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      amharicName: json['amharicName'],
      testament: json['testament'],
      chapters: json['chapters'],
      abbreviation: json['abbreviation'],
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _showSearch = false;
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _searchController.addListener(_filterBooks);
  }

  Future<void> _loadBooks() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/bible_books.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      List<dynamic> booksJson = jsonData['books'];

      setState(() {
        _allBooks = booksJson.map((json) => Book.fromJson(json)).toList();
        _filteredBooks = _allBooks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading books: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = _allBooks;
      } else {
        _filteredBooks = _allBooks
            .where((book) =>
                book.name.toLowerCase().contains(query) ||
                book.amharicName.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (!_showSearch) {
        _searchController.clear();
        _filteredBooks = _allBooks;
      }
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
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
                  hintText: 'Search books...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
              )
            : Text('Holy Bible'),
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
              tooltip: 'Search books',
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
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      drawer: BibleNavigationDrawer(), // Updated to use the renamed widget
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_showSearch)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = _filteredBooks[index];
                        return ListTile(
                          title: Text(
                            _selectedLanguage == 'English'
                                ? book.name
                                : book.amharicName,
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text('${book.chapters} chapters'),
                          onTap: () {
                            // Navigate to book chapters screen
                            print('Selected book: ${book.name}');
                          },
                        );
                      },
                    ),
                  )
                else
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16),
                          Text(
                            'Verse of the Day',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(height: 16),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: Colors.blue, width: 1),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'John 3:16',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[700],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          Divider(color: Colors.blue),
                          SizedBox(height: 24),
                          Center(
                            child: Text(
                              'Tap the menu icon to browse all books of the Bible',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[700],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
