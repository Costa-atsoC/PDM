import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme_provider.dart';
import '../common/Management.dart';

class WindowAppearance extends StatefulWidget {
  final Management refManagement;

  WindowAppearance(this.refManagement);

  @override
  State<WindowAppearance> createState() => _WindowAppearanceState();
}

class _WindowAppearanceState extends State<WindowAppearance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Selector'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return ListView(
            children: [
              RadioListTile<String>(
                title: Text('Light Theme'),
                value: 'light',
                groupValue: provider.selectedOption,
                onChanged: (value) {
                  provider.setSelectedOption(value!);
                  provider.changeTheme(value);
                },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<String>(
                title: Text('Dark Theme'),
                value: 'dark',
                groupValue: provider.selectedOption,
                onChanged: (value) {
                  provider.setSelectedOption(value!);
                  provider.changeTheme(value);
                },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile<String>(
                title: Text('System Theme'),
                value: 'system',
                groupValue: provider.selectedOption,
                onChanged: (value) {
                  provider.setSelectedOption(value!);
                  provider.changeTheme(value);
                },
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ],
          );
        },
      ),
    );
  }
}
