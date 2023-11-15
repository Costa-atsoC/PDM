import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Management.dart';
import 'Utils.dart';


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
  Future<void> Load() async
  {
    Utils.MSG_Debug(windowTitle+":Load");
  }
  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle+":createState");
    return State_windowSettings(this);
  }
//--------------
}
//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowSettings extends State<windowSettings> {
  final windowSettings Ref_Window;
  String className = "";

  //--------------
  State_windowSettings(this.Ref_Window)
      : super() {
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
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => windowSettings(Ref_Window.Ref_Management)));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text("Account", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Change Password"),

          ],
        )
      ),
    );
  }
  GestureDetector buildAccountOption(BuildContext context, String title){
    return GestureDetector(
      onTap: () {
        showDialog(context:context, builder: (BuildContext context){

        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]
            )),
            Icon(Icons.arrow_forward_ios, color: Colors.grey,)
          ],
        ),
      )
    );
  }
}
