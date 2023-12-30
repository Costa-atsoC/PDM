import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/Management.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';

class WindowLanguage extends StatefulWidget {
  final Management refManagement;

  WindowLanguage(this.refManagement);

  @override
  _WindowLanguageState createState() => _WindowLanguageState();
}

class _WindowLanguageState extends State<WindowLanguage> {
<<<<<<< Updated upstream
  String? _selectedLanguage;
=======
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage(); // Carrega o idioma ao iniciar o estado do widget
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString("LANGUAGE") ?? "EN"; // Carrega o idioma salvo ou define o padrão "EN"
    });
  }
>>>>>>> Stashed changes

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
                  // Adicione mais opções de idioma conforme necessário
                ],
              ),
            ),
          ),
<<<<<<< Updated upstream
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
              // Add more language options as needed
            ],
          ),
        ),
      ),
    );
  }

  RadioListTile<String> buildLanguageOption(String language, String languageCode) {
=======
        );
      },
    );
  }

  RadioListTile<String> buildLanguageOption(
      String language, String languageCode) {
    final isSelected = _selectedLanguage == languageCode;

>>>>>>> Stashed changes
    return RadioListTile<String>(
      title: Text(language),
      value: languageCode,
      groupValue: _selectedLanguage,
      onChanged: (String? value) {
        setState(() {
          _selectedLanguage = value!;
        });
        Utils.MSG_Debug('Selected Language: $_selectedLanguage');
        _saveLanguage(value); // Salva o idioma selecionado
        Navigator.pop(context);
      },
<<<<<<< Updated upstream
      controlAffinity: ListTileControlAffinity.trailing, // Aligns the radio button to the right
    );
  }
}
=======
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
>>>>>>> Stashed changes
