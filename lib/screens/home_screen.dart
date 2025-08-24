import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/navigation_drawer.dart';

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
          // Add vertical three dots menu
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == 'settings') {
                // Navigate to settings screen
              } else if (value == 'about') {
                // Navigate to about screen
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
          : Column(
              children: [
                // Header with testament filter
                Container(
                  color: Colors.grey[100],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Old Testament',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                      Text(
                        'New Testament',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                ),
                // Books list
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _showSearch ? _filteredBooks.length : _allBooks.length,
                    itemBuilder: (context, index) {
                      final book = _showSearch
                          ? _filteredBooks[index]
                          : _allBooks[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: book.testament == 'Old'
                              ? Colors.orange
                              : Colors.green,
                          child: Text(
                            book.abbreviation,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          _selectedLanguage == 'English'
                              ? book.name
                              : book.amharicName,
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text('${book.chapters} chapters'),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          // Navigate to book chapters screen
                          print('Selected book: ${book.name}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
