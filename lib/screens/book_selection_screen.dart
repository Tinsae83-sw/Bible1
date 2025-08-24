import 'package:flutter/material.dart';
import 'package:holy_bible/models/bible_book.dart';
import 'package:holy_bible/screens/chapter_selection_screen.dart';
import 'package:holy_bible/services/bible_service.dart';

class BookSelectionScreen extends StatefulWidget {
  @override
  _BookSelectionScreenState createState() => _BookSelectionScreenState();
}

class _BookSelectionScreenState extends State<BookSelectionScreen> {
  final BibleService _bibleService = BibleService();
  List<BibleBook> _oldTestamentBooks = [];
  List<BibleBook> _newTestamentBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      final books = await _bibleService.getBooks();
      setState(() {
        _oldTestamentBooks = books.where((b) => b.testament == "Old").toList();
        _newTestamentBooks = books.where((b) => b.testament == "New").toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error loading books: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Select Book"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Old Testament"),
              Tab(text: "New Testament"),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildBooksList(_oldTestamentBooks),
                  _buildBooksList(_newTestamentBooks),
                ],
              ),
      ),
    );
  }

  Widget _buildBooksList(List<BibleBook> books) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          title: Text(book.name),
          subtitle: Text(book.amharicName),
          trailing: Text("${book.chapters} ch"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChapterSelectionScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }
}
