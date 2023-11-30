import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/Management.dart';
import 'common/Utils.dart';
import 'common/appTheme.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowSettings extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

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
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text(className, style: const TextStyle(fontSize: 22)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: [
                const SizedBox(height: 40),
                const Row(
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
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 20),
                buildAccountOption(context, "Change Password",
                    actions: ['Yes', 'No']),
                buildAccountOption(context, "Appearance",
                    actions: ['Device Theme', 'Dark Theme', 'Light Theme']),
                const SizedBox(height: 40),
                const Row(
                  children: [
                    Icon(Icons.volume_up_outlined),
                    SizedBox(width: 10),
                    Text("Notifications",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))
                  ],
                ),
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 10),
                buildNotificationOption(
                    "Notifications", valNotify1, onChangeFunction1),
                buildNotificationOption(
                    "Notifications", valNotify2, onChangeFunction2),
                buildNotificationOption(
                    "Notifications", valNotify3, onChangeFunction3),
                const Divider(height: 20, thickness: 1),
                const SizedBox(height: 10),
                Center(
                    child: Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 20, right: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // padding: const EdgeInsets.symmetric(horizontal: 100),
                    ),
                    onPressed: () {},
                    child: Text(
                      "SIGN OUT",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ))
              ],
            )),
      ),
    );
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
              activeColor: Theme.of(context).colorScheme.secondaryContainer,
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

  GestureDetector buildAccountOption(BuildContext context, String title,
      {List<String>? actions}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (actions != null && actions.isNotEmpty)
                    for (var action in actions)
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para as ações do "Appearance"
                          if (action == 'Device Theme') {
                            // Lógica para 'Device Theme'
                            Navigator.of(context).pop();
                          } else if (action == 'Dark Theme') {
                            // Lógica para 'Dark Theme'
                            Navigator.of(context).pop();
                          } else if (action == 'Light Theme') {
                            // Lógica para 'Light Theme'
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(action),
                      )
                  else
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: Text('Device Theme'),
                          value: 'Device Theme',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Dark Theme'),
                          value: 'Dark Theme',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Light Theme'),
                          value: 'Light Theme',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
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
            ),
          ],
        ),
      ),
    );
  }
}
