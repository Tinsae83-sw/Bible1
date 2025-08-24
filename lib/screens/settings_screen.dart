// screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  final List<String> _availableFonts = ['Roboto', 'AbyssinicaSIL'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.loadSettings();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ValueListenableBuilder<String>(
        valueListenable: _settingsService.fontFamilyNotifier,
        builder: (context, fontFamily, child) {
          return ValueListenableBuilder<double>(
            valueListenable: _settingsService.fontSizeNotifier,
            builder: (context, fontSize, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Font Family Setting
                    Text(
                      'Font Family',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: fontFamily,
                        isExpanded: true,
                        underline: const SizedBox(), // Remove default underline
                        items: _availableFonts.map((String font) {
                          return DropdownMenuItem<String>(
                            value: font,
                            child: Text(
                              font,
                              style: TextStyle(fontFamily: font),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            _settingsService.updateFontFamily(newValue);
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Font Size Setting
                    Text(
                      'Font Size: ${fontSize.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: fontSize,
                      min: 8.0,
                      max: 32.0,
                      divisions: 24,
                      label: fontSize.toStringAsFixed(1),
                      onChanged: (double value) {
                        _settingsService.updateFontSize(value);
                      },
                    ),

                    const SizedBox(height: 20),

                    // Preview Section
                    Text(
                      'Preview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John 3:16',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: fontSize,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'ዮሐንስ ፫:፲፮',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'እግዚአብሔር ለዓለም ፍቅር አደረገላትና እንደሆነም አንድያ ልጁን ለሚያምን ሁሉ ላለመጥፋት ግን የዘላለም ሕይወት እንዲኖረው ሰጠ።',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontSize: fontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
