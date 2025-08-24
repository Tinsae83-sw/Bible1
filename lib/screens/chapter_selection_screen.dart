import 'package:flutter/material.dart';
import 'package:holy_bible/models/bible_book.dart';
import 'package:holy_bible/screens/reading_screen.dart';

class ChapterSelectionScreen extends StatelessWidget {
  final BibleBook book;

  ChapterSelectionScreen({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${book.name} Chapters")),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: book.chapters,
        itemBuilder: (context, index) {
          final chapter = index + 1;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingScreen(
                    book: book,
                    chapterNumber: chapter,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "$chapter",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
