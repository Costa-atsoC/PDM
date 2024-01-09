import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Utils.dart';

import '../common/Management.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';
import '../windowHome.dart';

class WindowLanguage extends StatefulWidget {
  final Management Ref_Management;

  WindowLanguage(this.Ref_Management);

  @override
  _WindowLanguageState createState() => _WindowLanguageState();

  Future NavigateTo_Window_Home(context) async {
    windowHome Jan = windowHome(Ref_Management);
    await Jan.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Jan));
  }
}

class _WindowLanguageState extends State<WindowLanguage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString("LANGUAGE") ?? "EN";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          theme: provider.currentTheme,
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                widget.Ref_Management.GetDefinicao(
                  "WND_LANGUAGE_TITLE", "Select Language",
                ),
                style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onPrimary),
              ),
              centerTitle: true,
            ),
            body: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLanguageOption('WND_LANGUAGE_OPTION_PT', 'PT'),
                  buildLanguageOption('WND_LANGUAGE_OPTION_EN', 'EN'),
                  buildLanguageOption('WND_LANGUAGE_OPTION_DE', 'DE'),
                  // Add more language options as needed
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  RadioListTile<String> buildLanguageOption(
      String languageDefinition, String languageCode) {
    final isSelected = _selectedLanguage == languageCode;
    final language = widget.Ref_Management.GetDefinicao(languageDefinition, languageCode);

    return RadioListTile<String>(
      title: Text(language),
      value: languageCode,
      groupValue: _selectedLanguage,
      onChanged: (String? value) {
        setState(() {
          _selectedLanguage = value!;
        });
        Utils.MSG_Debug('Selected Language: $_selectedLanguage');
        _saveLanguage(value);
        widget.NavigateTo_Window_Home(context);
      },
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: Theme.of(context).colorScheme.primaryContainer,
      selected: isSelected,
    );
  }

  void _saveLanguage(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("LANGUAGE", value ?? "");
  }
}