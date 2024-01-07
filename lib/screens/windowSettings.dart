import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ubi/screens/windowAppearance.dart';
import 'package:ubi/screens/windowDeleteAccount.dart';
import 'package:ubi/screens/windowsLanguage.dart';
import '../common/theme_provider.dart';
import 'windowChangePassword.dart';
// import 'windowLanguage.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowSettings extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  String selectedLanguage = "";

  //--------------
  windowSettings(this.Ref_Management) {
    windowTitle = "General Window";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowSettings(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowSettings extends State<windowSettings> {
  String _selectedColor = "Light";
  List<String> _colors = ["Dark", "Light"];
  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;

  String selectedOption = '';

  void onChangeFunction1(bool newValue) {
    setState(() {
      if (!newValue) {
        valNotify1 = false;
        valNotify2 = true; // Se valNotify1 for desligado, valNotify2 é ligado
      }
    });
  }

  void onChangeFunction2(bool newValue) {
    setState(() {
      if (valNotify2 && !newValue) {
        valNotify2 = false;
        // Se valNotify2 estiver ligado e for desligado, não muda valNotify1
      }
    });
  }

  void onChangeFunction3(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
    });
  }

  final windowSettings Ref_Window;
  String className = "";

  //--------------
  State_windowSettings(this.Ref_Window) : super() {
    className = "Settings";
    Utils.MSG_Debug("$className: createState");
  }

  //--------------
  @override
  void dispose() {
    Utils.MSG_Debug("createState");
    super.dispose();
    Utils.MSG_Debug("$className:dispose");
  }

  //--------------
  @override
  void deactivate() {
    Utils.MSG_Debug("$className:deactivate");
    super.deactivate();
  }

  //--------------
  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("$className: didChangeDependencies");
    super.didChangeDependencies();
  }

  //--------------
  @override
  void initState() {
    Utils.MSG_Debug("$className: initState");
    super.initState();
  }

  void NavigateTo_New_Window(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => windowSettings(Ref_Window.Ref_Management)));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
          theme: provider.currentTheme,
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(className, style: TextStyle(fontSize: 22)),
              centerTitle: true,
            ),
            body: Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                        ),
                        SizedBox(width: 10),
                        Text("Account",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(height: 20),
                    buildAccountOption(context, "Change Password",
                        actions: ['Yes', 'No']),
                    buildAccountOption(context, "Appearance",
                        actions: ['Device Theme', 'Dark Theme', 'Light Theme']),
                    buildAccountOption(context, "Language", actions: []),
                    buildAccountOption(context, "Delete Account", actions: []),
                    buildAccountOption(context, "Delete Cache", actions: []),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Icon(Icons.volume_up_outlined),
                        SizedBox(width: 10),
                        Text("Notifications",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold))
                      ],
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(height: 10),
                    buildNotificationOption(
                        "Notifications", valNotify1, onChangeFunction1),
                    buildNotificationOption(
                        "Notifications", valNotify2, onChangeFunction2),
                    buildNotificationOption(
                        "Notifications", valNotify3, onChangeFunction3),
                    Divider(height: 20, thickness: 1),
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        // Add a bottom margin here
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                            ),
                          ),
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          child: ListTile(
                              title: Align(
                                child: Text(
                                  Ref_Window.Ref_Management.SETTINGS.Get(
                                      "WND_HOME_DRAWER_SUBTITLE_5", "LOGOUT"),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(),
                                ),
                              ),
                              onTap: () {}),
                        ),
                      ),
                    )
                  ],
                )),
          ));
    });
  }

  Padding buildNotificationOption(
      String title, bool value, Function onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600])),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          )
        ],
      ),
    );
  }

  void changeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var color in _colors)
                  RadioListTile<String>(
                    title: Text(color),
                    value: color,
                    groupValue: _selectedColor,
                    onChanged: (value) {
                      setState(() {
                        _selectedColor = value!;
                      });
                      print(_selectedColor);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Portuguese'),
                onTap: () {
                  setState(() {
                    // Define a linguagem como português e armazena nas preferências compartilhadas
                    widget.selectedLanguage = 'Portuguese';
                    Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
                        "LANGUAGE", 'PT');
                    Ref_Window.Ref_Management.Load();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    // Define a linguagem como inglês e armazena nas preferências compartilhadas
                    widget.selectedLanguage = 'English';
                    Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
                        "LANGUAGE", 'EN');
                    Ref_Window.Ref_Management.Load();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Deutsch'),
                onTap: () {
                  setState(() {
                    // Define a linguagem como inglês e armazena nas preferências compartilhadas
                    widget.selectedLanguage = 'Deutsch';
                    Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
                        "LANGUAGE", 'DE');
                    Ref_Window.Ref_Management.Load();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Delete cache?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Delete'),
                onTap: () {
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Cancel'),
                onTap: () {
                  setState(() {
                    // Define a linguagem como inglês e armazena nas preferências compartilhadas
                    widget.selectedLanguage = 'English';
                    Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
                        "LANGUAGE", 'EN');
                    Ref_Window.Ref_Management.Load();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title,
      {List<String>? actions}) {
    return GestureDetector(
      onTap: () {
        if (title == 'Change Password') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WindowChangePassword(Ref_Window.Ref_Management)),
          );
        } else if (title == 'Delete Account') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WindowDeleteAccount(Ref_Window.Ref_Management)),
          );
        } else if (title == 'Language') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WindowLanguage(Ref_Window.Ref_Management)),
          );
        } else if (title == 'Appearance') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WindowAppearance(Ref_Window.Ref_Management)),
          );
        } else if (title == 'Delete Cache') {
        } else {
          // Se houver outras opções de conta
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  // Restante do seu código para outras opções...
                  );
            },
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
