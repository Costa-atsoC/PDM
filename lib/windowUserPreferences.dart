import 'package:flutter/material.dart';

import 'Management.dart';
import 'Utils.dart';


//----------------------------------------------------------------
//----------------------------------------------------------------
class windowGeneral extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  //--------------
  windowGeneral(this.Ref_Management) {
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
    return State_windowGeneral(this);
  }
//--------------
}
//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowGeneral extends State<windowGeneral> {
  final windowGeneral Ref_Window;
  String className = "";
  //--------------
  State_windowGeneral(this.Ref_Window)
      : super()
  {
    className = "State_windowGeneral";
    Utils.MSG_Debug("$className: createState");
  }
  //--------------
  @override
  void dispose()  {
    Utils.MSG_Debug("createState");
    super.dispose();
    Utils.MSG_Debug("$className:dispose");
  }
  //--------------
  @override
  void deactivate()  {
    Utils.MSG_Debug("$className:deactivate");
    super.deactivate();
  }
  //--------------
  @override
  void didChangeDependencies()  {
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => windowGeneral(Ref_Window.Ref_Management)));
  }
  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    /*
    return Container(
        height: 40.0,
        child: TextButton(
        onPressed: () async {
            UteisFlutter.MSG("Carregou no botão");
            Navegar_Nova_Janela(context);
         },
          child: Text("Botão"),
    ),
    );*/
    return
      Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(className),
        ),
        body:
        Container(
          //      height: 40.0,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 30),),
            onPressed: () async {
              UtilsFlutter.MSG("Carregou no botão");
              NavigateTo_New_Window(context);
            },
            child: Text(Ref_Window.Ref_Management.GetDefinicao("ACCAO_BTN_??", "Accao-BTN_?? ??")),
          ),
        ),
      );
  }
//--------------
//--------------
//--------------
}