import 'package:flutter/material.dart';
import '../services/bible_service.dart';
import '../models/bible_book.dart';
import '../screens/reading_screen.dart';

class BibleNavigationDrawer extends StatefulWidget {
  const BibleNavigationDrawer({super.key});

  @override
  State<BibleNavigationDrawer> createState() => _BibleNavigationDrawerState();
}

class _BibleNavigationDrawerState extends State<BibleNavigationDrawer> {
  final BibleService _bibleService = BibleService();
  List<BibleBook>? _books;
  List<BibleBook>? _oldTestamentBooks;
  List<BibleBook>? _newTestamentBooks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final books = await _bibleService.getBooks();
    setState(() {
      _books = books;
      _oldTestamentBooks =
          books.where((book) => book.testament == "Old").toList();
      _newTestamentBooks =
          books.where((book) => book.testament == "New").toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.blue[700],
            ),
            child: Image.asset(
              'assets/images/devid1.jpeg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'Old Testament',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      ..._oldTestamentBooks!.map((book) => ListTile(
                            leading: Checkbox(
                              value: false,
                              onChanged: (bool? value) {},
                              activeColor: Colors.blue,
                            ),
                            title: Text(
                              book.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              '${book.chapters} ch',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadingScreen(
                                    book: book,
                                    chapterNumber: 1,
                                  ),
                                ),
                              );
                            },
                          )),
                      const Divider(color: Colors.blue),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text(
                          'New Testament',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      ..._newTestamentBooks!.map((book) => ListTile(
                            leading: Checkbox(
                              value: true,
                              onChanged: (bool? value) {},
                              activeColor: Colors.blue,
                            ),
                            title: Text(
                              book.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              '${book.chapters} ch',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReadingScreen(
                                    book: book,
                                    chapterNumber: 1,
                                  ),
                                ),
                              );
                            },
                          )),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
