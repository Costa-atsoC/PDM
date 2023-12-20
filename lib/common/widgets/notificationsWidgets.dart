import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../Management.dart';
import '../Utils.dart';
import '../appTheme.dart';


//----------------------------------------------------------------
//----------------------------------------------------------------
class windowNotifications extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  //--------------
  windowNotifications(this.Ref_Management) {
    windowTitle = "Search Window";
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
    return State_windowSearch(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowSearch extends State<windowNotifications> {
  final formKey = GlobalKey<FormState>();



  final windowNotifications Ref_Window;
  String className = "";

  //--------------
  State_windowSearch(this.Ref_Window) : super() {
    className = "State_windowSearch";
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

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  final FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation
      .endDocked; //FloatingActionButtonLocation.endDocked;

  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

    );
  }

//--------------
//--------------
//--------------
}
