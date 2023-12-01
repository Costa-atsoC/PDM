import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/Management.dart';
import 'windowGeneral.dart';
import '../common/Utils.dart';

// APOIO EM : https://api.flutter.dev/flutter/widgets/ListView-class.html
//----------------------------------------------------------------
//----------------------------------------------------------------
class windowListView extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  int? ACCESS_WINDOW_LISTVIEW;

  //--------------
  windowListView(this.Ref_Management) {
    windowTitle = "JanelaListView";
    Utils.MSG_Debug(windowTitle);
  }
  //--------------
  Future<void> Load() async
  {
    Utils.MSG_Debug(windowTitle+":Load");
    ACCESS_WINDOW_LISTVIEW = await Ref_Management.Get_SharedPreferences_INT("JANELA_LISTVIEW");
    Ref_Management.Save_Shared_Preferences_INT("JANELA_LISTVIEW", ACCESS_WINDOW_LISTVIEW! + 1);
  }
  //--------------
  int? Get_ACCESS_WINDOW_LISTVIEW()
  {
    return ACCESS_WINDOW_LISTVIEW;
  }
  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle+":createState");
    return State_windowListView(this);
  }
//--------------
}
//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowListView extends State<windowListView> {
  final windowListView Ref_Window;
  String className = "";
  //--------------
  State_windowListView(this.Ref_Window)
      : super()
  {
    className = "Estado_JanelaListView: ${Ref_Window.Get_ACCESS_WINDOW_LISTVIEW()}";
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
  Widget Create_Fixed_ListView()
  {
    return
      ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text('Entry A')),
          ),
          Container(
            height: 50,
            color: Colors.amber[500],
            child: const Center(child: Text('Entry B')),
          ),
          Container(
            height: 50,
            color: Colors.amber[100],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      );
  }
  //--------------
  Widget Create_Dynamic_ListView()
  {
    //List<String> entries = <String>['A', 'B', 'C'];
    // List<int> colorCodes = <int>[600, 500, 100];

    List<String> entries = [];
    List<int> colorCodes = [];
    for (int i = 0; i < 50; i++)
    {
      entries.add('Item ---> ' + i.toString());
      colorCodes.add(Random().nextInt(6) * 100 + 100);
    }
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: ListTile(
              title: Text('Entry ${entries[index]}'),
              onLongPress: ()
              {
                UtilsFlutter.MSG("Estas a pressionar-me! ACCAO: ${entries[index]}");
              },
              onTap: ()
              {
                UtilsFlutter.MSG("Picaste-me! ACCAO: ${entries[index]}");
                NavigateTo_New_Window(context);
              }, // Handle your onTap here.

            ),
          );
        }
    );
  }
  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    return
      Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(className),
          ),
          body: //Criar_ListView_Fixa()
          Create_Dynamic_ListView()
      );
  }
//--------------
//--------------
//--------------
}