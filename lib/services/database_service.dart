// services/database_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';
import '../models/bible_verse.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await _prefs;
    await prefs.setString('userPreferences', json.encode(preferences.toJson()));
  }

  Future<UserPreferences> getUserPreferences() async {
    final prefs = await _prefs;
    final String? preferencesString = prefs.getString('userPreferences');

    if (preferencesString != null) {
      final Map<String, dynamic> preferencesMap =
          json.decode(preferencesString);
      return UserPreferences.fromJson(preferencesMap);
    }

    return UserPreferences();
  }

  Future<void> saveBookmark(BibleVerse verse) async {
    final prefs = await _prefs;
    final String key =
        'bookmark_${verse.bookId}_${verse.chapterNumber}_${verse.verseNumber}';
    await prefs.setString(key, json.encode(verse.toJson()));
  }

  Future<void> removeBookmark(BibleVerse verse) async {
    final prefs = await _prefs;
    final String key =
        'bookmark_${verse.bookId}_${verse.chapterNumber}_${verse.verseNumber}';
    await prefs.remove(key);
  }

  Future<List<BibleVerse>> getBookmarks() async {
    final prefs = await _prefs;
    final keys =
        prefs.getKeys().where((key) => key.startsWith('bookmark_')).toList();
    List<BibleVerse> bookmarks = [];

    for (String key in keys) {
      final String? verseString = prefs.getString(key);
      if (verseString != null) {
        final Map<String, dynamic> verseMap = json.decode(verseString);
        bookmarks.add(BibleVerse.fromJson(verseMap));
      }
    }

    return bookmarks;
  }

  Future<bool> isBookmarked(BibleVerse verse) async {
    final prefs = await _prefs;
    final String key =
        'bookmark_${verse.bookId}_${verse.chapterNumber}_${verse.verseNumber}';
    return prefs.containsKey(key);
  }
}
