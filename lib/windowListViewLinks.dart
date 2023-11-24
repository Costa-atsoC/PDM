import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/Management.dart';
import 'windowGeneral.dart';
import 'common/Utils.dart';

// APOIO EM : https://api.flutter.dev/flutter/widgets/ListView-class.html
//----------------------------------------------------------------
//----------------------------------------------------------------
class windowListViewLinks extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  int? ACCESS_WINDOW_LISTVIEW_LINKS;
  List<String> entries = [];
  List<int> colorCodes = [];

  //--------------
  windowListViewLinks(this.Ref_Management) {
    windowTitle = "JanelaListViewLinks";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
    ACCESS_WINDOW_LISTVIEW_LINKS =
        await Ref_Management.Get_SharedPreferences_INT(
            "ACESSO_JANELA_LISTVIEW_LINKS");
    Ref_Management.Save_Shared_Preferences_INT(
        "ACESSO_JANELA_LISTVIEW_LINKS", ACCESS_WINDOW_LISTVIEW_LINKS! + 1);

    entries.add(
        'https://medium.flutterdevs.com/parse-and-display-xml-data-in-flutter-4629c03e0054');
    entries.add('https://api.flutter.dev/flutter/widgets/ListView-class.html');
    entries.add(
        'https://medium.com/flutter-community/flutter-adding-separator-in-listview-c501fe568c76');
    entries.add('https://pub.dev/packages/url_launcher/example');

    for (int i = 0; i < entries.length; i++) {
      colorCodes.add(Random().nextInt(6) * 100 + 100);
      //colorCodes.add(Colors.blue as int);
    }
  }

  //--------------
  int? Get_ACCESS_WINDOW_LISTVIEW_LINKS() {
    return ACCESS_WINDOW_LISTVIEW_LINKS;
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowListViewLinks(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowListViewLinks extends State<windowListViewLinks> {
  final windowListViewLinks Ref_Window;
  String className = "";

  //--------------
  State_windowListViewLinks(this.Ref_Window) : super() {
    className =
        "State_windowListViewLinks: ${Ref_Window.Get_ACCESS_WINDOW_LISTVIEW_LINKS()}";
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

  void Navegar_Nova_Janela(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => windowGeneral(Ref_Window.Ref_Management)));
  }

  //--------------
  Widget Create_Dynamic_ListView() {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
        padding: const EdgeInsets.all(8),
        itemCount: Ref_Window.entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //height: 50,
            color: Colors.amber[Ref_Window.colorCodes[index]],
            child: ListTile(
              title: Text('Entry ${Ref_Window.entries[index]}'),
              onLongPress: () {
                UtilsFlutter.MSG(
                    "Estas a pressionar-me! ACCAO: ${Ref_Window.entries[index]}");
              },
              onTap: () async {
                UtilsFlutter.MSG(
                    "Picaste-me! ACCAO: ${Ref_Window.entries[index]}");
                var url = Uri.parse(Ref_Window.entries[index]);
                await launchUrl(url);
              }, // Handle your onTap here.
            ),
          );
        });
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(className),
        ),
        body: Create_Dynamic_ListView());
  }
//--------------
//--------------
//--------------
}
