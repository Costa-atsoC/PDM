import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'windowHome.dart';

import 'Management.dart';
import 'Utils.dart';
import 'authenticationManager.dart';
import 'database_help.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowRegister extends StatefulWidget {
  String Titulo_Janela = "";
  final Management Ref_Management;

  //--------------
  windowRegister(this.Ref_Management) {
    Titulo_Janela = "Register";
    Utils.MSG_Debug(Titulo_Janela);
  }

  //--------------
  Future<void> Load() async {
    DatabaseHelper.db();
    Utils.MSG_Debug(Titulo_Janela + ":Load");
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(Titulo_Janela + ":createState");
    return Estado_windowRegister(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class Estado_windowRegister extends State<windowRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // _formKey
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  final windowRegister Ref_Window;

  String Nome_Classe = "";

  //--------------
  Estado_windowRegister(this.Ref_Window) : super() {
    Nome_Classe = Ref_Window.Ref_Management.SETTINGS
        .Get("JNL_REGISTER_TITLE_1", "JNL_REGISTER_HINT_1 ??");
    Utils.MSG_Debug("$Nome_Classe: createState");
  }

  //--------------
  @override
  void dispose() {
    Utils.MSG_Debug("createState");
    super.dispose();
    Utils.MSG_Debug("$Nome_Classe:dispose");
  }

  //--------------
  @override
  void deactivate() {
    Utils.MSG_Debug("$Nome_Classe:deactivate");
    super.deactivate();
  }

  //--------------
  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("$Nome_Classe: didChangeDependencies");
    super.didChangeDependencies();
  }

  //--------------
  @override
  void initState() {
    Utils.MSG_Debug("$Nome_Classe: initState");
    super.initState();
  }

  //--------- window Home
  Future NavigateTo_Window_Home(context) async {
    windowHome win = new windowHome(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$Nome_Classe: build");

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(Nome_Classe),
      ),
      body: Container(
        //  height: 40.0,
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(130),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage('assets/PORSCHE_MAIN_2.jpeg'),
                  ),
                ),
                TextFormField(
                  controller: _username,
                  keyboardType: TextInputType.text,
                  obscureText: bool.parse(Ref_Window.Ref_Management.SETTINGS
                      .Get("JNL_REGISTER_OBSTEXT_1", "true")),
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(Icons.email), //icon of text field
                    labelText: Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_REGISTER_HINT_1", "JNL_REGISTER_HINT_1 ??"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.text,
                  obscureText: bool.parse(Ref_Window.Ref_Management.SETTINGS
                      .Get("JNL_REGISTER_OBSTEXT_2", "true")),
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    icon: Icon(Icons.alternate_email), //icon of text field
                    labelText: Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_REGISTER_HINT_2", "JNL_REGISTER_HINT_2 ??"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },
                ),
                TextFormField(
                  controller: _pass,
                  decoration: InputDecoration(
                    icon: Icon(Icons.password), //icon of text field
                    labelText: Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_REGISTER_HINT_3", "JNL_REGISTER_HINT_3 ??"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPass,
                  decoration: InputDecoration(
                    icon: Icon(Icons.password_outlined),
                    //icon of text field
                    labelText: Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_REGISTER_HINT_4", "JNL_REGISTER_HINT_4 ??"),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value != _pass.text) {
                      return 'Not Match';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      UtilsFlutter.MSG('HOME');
                      NavigateTo_Window_Home(context);
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        int userId = Authentication.createUser(
                            _username.text, _email.text, _pass.text) as int;
                        Utils.MSG_Debug((userId) as String);
                      }
                    },
                    child: Text(Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_REGISTER_BTN_1", "JNL_REGISTER_BTN_1 ??")),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
//--------------
//--------------
//--------------
}
