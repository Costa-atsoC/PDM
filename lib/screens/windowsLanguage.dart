import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/Management.dart';
import '../common/theme_provider.dart';

class WindowLanguage extends StatefulWidget {
  final Management refManagement;

  WindowLanguage(this.refManagement);

  @override
  _WindowLanguageState createState() => _WindowLanguageState();
}

class _WindowLanguageState extends State<WindowLanguage> {
  String? _selectedLanguage = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        theme: provider.currentTheme,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text('Select Language', style: TextStyle(fontSize: 22)),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildLanguageOption('Portuguese', 'PT'),
                buildLanguageOption('English', 'EN'),
                buildLanguageOption('Deutsch', 'DE')
                // Add more language options as needed
              ],
            ),
          ),
        ),
      );
    });
  }

  RadioListTile<String> buildLanguageOption(
      String language, String languageCode) {
    bool isSelected = _selectedLanguage == languageCode;

    return RadioListTile<String>(
      title: Text(language),
      value: languageCode,
      groupValue: _selectedLanguage,
      onChanged: (String? value) {
        setState(() {
          _selectedLanguage = value;
        });
        Utils.MSG_Debug('Selected Language: $_selectedLanguage');
        widget.refManagement
            .Save_Shared_Preferences_STRING("LANGUAGE", value ?? "");
        widget.refManagement.Load();
        Utils.MSG_Debug(value!);
        Navigator.pop(context);
      },
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: Theme.of(context).colorScheme.primaryContainer,
      // Color when selected
      selected: isSelected, // Whether the current option is selected
    );
  }
}
