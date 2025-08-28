// widgets/navigation_drawer.dart
import 'package:flutter/material.dart';
import 'package:holy_bible/services/bible_service.dart';
import 'package:holy_bible/models/bible_book.dart';
import 'package:holy_bible/screens/chapter_selection_screen.dart';

class BibleNavigationDrawer extends StatefulWidget {
  const BibleNavigationDrawer({super.key});

  @override
  State<BibleNavigationDrawer> createState() => _BibleNavigationDrawerState();
}

class _BibleNavigationDrawerState extends State<BibleNavigationDrawer> {
  final BibleService _bibleService = BibleService();
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
      _oldTestamentBooks =
          books.where((book) => book.testament == "Old").toList();
      _newTestamentBooks =
          books.where((book) => book.testament == "New").toList();
      _isLoading = false;
    });
  }

  void _navigateToChapterSelection(BibleBook book) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterSelectionScreen(
            initialBook: book), // Changed from 'book' to 'initialBook'
      ),
    );
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
                      _buildTestamentSection(
                          "Old Testament", _oldTestamentBooks!),
                      const Divider(color: Colors.blue),
                      _buildTestamentSection(
                          "New Testament", _newTestamentBooks!),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestamentSection(String title, List<BibleBook> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
        ),
        ...books.map((book) => BookListTile(
              book: book,
              onTap: () => _navigateToChapterSelection(book),
            )),
      ],
    );
  }
}

class BookListTile extends StatelessWidget {
  final BibleBook book;
  final VoidCallback onTap;

  const BookListTile({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.book, color: Colors.blue),
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
      onTap: onTap,
    );
  }
}
