import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedFont = 'Roboto';
  final List<String> _availableFonts = ['Roboto', 'AbyssinicaSIL'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedFont = prefs.getString('selected_font') ?? 'Roboto';
    });
  }

  Future<void> _saveFont(String font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_font', font);
    setState(() {
      _selectedFont = font;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Font Family',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedFont,
              items: _availableFonts.map((String font) {
                return DropdownMenuItem<String>(
                  value: font,
                  child: Text(font),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _saveFont(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
