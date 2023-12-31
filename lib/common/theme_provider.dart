import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appTheme.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _currentTheme;
  late String _selectedOption;
  late Brightness _platformBrightness; // Armazenando o brilho da plataforma

  ThemeProvider() {
    _selectedOption = 'system'; // Inicializa a opção como 'system'
    initialize();
    _platformBrightness = WidgetsBinding.instance!.window.platformBrightness;
    _initPlatformBrightnessListener(); // Inicia o listener para mudanças de brilho
  }

  ThemeData get currentTheme => _currentTheme; // Getter para acessar o tema atual

  String get selectedOption => _selectedOption;

  void setSelectedOption(String option) {
    _selectedOption = option;
    notifyListeners();
  }

  Future<void> changeTheme(String theme) async {
    switch (theme) {
      case 'light':
        _currentTheme = AppTheme.lightTheme;
        break;
      case 'dark':
        _currentTheme = AppTheme.darkTheme;
        break;
      case 'system':
        _currentTheme = _platformBrightness == Brightness.light ? AppTheme.lightTheme : AppTheme.darkTheme;
        break;
      default:
        _currentTheme = AppTheme.lightTheme;
        break;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);

    notifyListeners();
  }

  Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _currentTheme = AppTheme.lightTheme;
    } else if (theme == 'dark') {
      _currentTheme = AppTheme.darkTheme;
    } else {
      _currentTheme = _platformBrightness == Brightness.light ? AppTheme.lightTheme : AppTheme.darkTheme;
    }

    notifyListeners();
  }

  void _initPlatformBrightnessListener() {
    WidgetsBinding.instance!.window.onPlatformBrightnessChanged = () {
      _platformBrightness = WidgetsBinding.instance!.window.platformBrightness;
      if (_selectedOption == 'system') {
        changeTheme('system');
      }
    };
  }
}