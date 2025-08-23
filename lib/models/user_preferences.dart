// models/user_preferences.dart
import 'dart:convert';

class UserPreferences {
  final double fontSize;
  final String fontFamily;
  final bool isDarkModeEnabled;
  final String primaryColor;
  final String? lastReadBook;
  final int? lastReadChapter;
  final int? lastReadVerse;

  UserPreferences({
    this.fontSize = 16.0,
    this.fontFamily = 'AbyssinicaSIL',
    this.isDarkModeEnabled = false,
    this.primaryColor = 'blue',
    this.lastReadBook,
    this.lastReadChapter,
    this.lastReadVerse,
  });

  UserPreferences copyWith({
    double? fontSize,
    String? fontFamily,
    bool? isDarkModeEnabled,
    String? primaryColor,
    String? lastReadBook,
    int? lastReadChapter,
    int? lastReadVerse,
  }) {
    return UserPreferences(
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      isDarkModeEnabled: isDarkModeEnabled ?? this.isDarkModeEnabled,
      primaryColor: primaryColor ?? this.primaryColor,
      lastReadBook: lastReadBook ?? this.lastReadBook,
      lastReadChapter: lastReadChapter ?? this.lastReadChapter,
      lastReadVerse: lastReadVerse ?? this.lastReadVerse,
    );
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      fontSize: json['fontSize'] ?? 16.0,
      fontFamily: json['fontFamily'] ?? 'AbyssinicaSIL',
      isDarkModeEnabled: json['isDarkModeEnabled'] ?? false,
      primaryColor: json['primaryColor'] ?? 'blue',
      lastReadBook: json['lastReadBook'],
      lastReadChapter: json['lastReadChapter'],
      lastReadVerse: json['lastReadVerse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'isDarkModeEnabled': isDarkModeEnabled,
      'primaryColor': primaryColor,
      'lastReadBook': lastReadBook,
      'lastReadChapter': lastReadChapter,
      'lastReadVerse': lastReadVerse,
    };
  }
}
