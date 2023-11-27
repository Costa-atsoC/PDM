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

  onChangeFunction1(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
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
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      SizedBox(width: 10),
                      Text("Account",
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Divider(height: 20, thickness: 1),
                  SizedBox(height: 10),
                  buildAccountOption(context, "Change Password"),
                  buildAccountOption(context, "Change Password"),
                  buildAccountOption(context, "Change Password"),
                  buildAccountOption(context, "Change Password"),
                  buildAccountOption(context, "Change Password"),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Icon(Icons.volume_up_outlined, color: Theme.of(context).colorScheme.onPrimary,),
                      SizedBox(width: 10),
                      Text("Notifications",
                          style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
                    ],
                  ),
                  Divider(height: 20, thickness: 1),
                  SizedBox(height: 10),
                  buildNotificationOption(
                      "Theme Dark", valNotify1, onChangeFunction1),
                  buildNotificationOption(
                      "Theme Dark", valNotify2, onChangeFunction2),
                  buildNotificationOption(
                      "Theme Dark", valNotify3, onChangeFunction3),
                  Center(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {},
                      child: Text(
                        "SIGN OUT",
                        style: Theme.of(context).textTheme.titleMedium
                      ),
                    ),
                  )
                ],
              )),
        )
    );
  }

  Padding buildNotificationOption(String title, bool value,
      Function onChangeMethod) {
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

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text("Option 1"), Text("Option 2")],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close"))
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600])),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              )
            ],
          ),
        ));
  }
}
