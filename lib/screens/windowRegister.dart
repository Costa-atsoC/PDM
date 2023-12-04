import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ubi/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:ubi/screens/windowInitial.dart';

import '../../firestore/user_firestore.dart';
import '../common/appTheme.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../windowHome.dart';
import '../common/Management.dart';
import '../common/Utils.dart';

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
  final TextEditingController _fullname = TextEditingController();

  final FirebaseAuthService _auth = FirebaseAuthService();

  final windowRegister Ref_Window;

  String Nome_Classe = "";

  //--------------
  Estado_windowRegister(this.Ref_Window) : super() {
    Nome_Classe = Ref_Window.Ref_Management.SETTINGS
        .Get("WND_REGISTER_TITLE_1", "WND_REGISTER_HINT_1 ??");
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
    MyHomePage win = MyHomePage(Ref_Window.Ref_Management,
        Ref_Window.Ref_Management.GetDefinicao("TITULO_APP", "TITULO_APP ??"));
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$Nome_Classe: build");

    return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                //  height: 40.0,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            backgroundImage: AssetImage('assets/LOGO.png'),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.email), //icon of text field
                            iconColor: Theme.of(context).iconTheme.color,
                            labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                                "WND_REGISTER_HINT_1",
                                "WND_REGISTER_HINT_1 ??"),
                            labelStyle: Theme.of(context).textTheme.titleSmall,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                        TextFormField(
                          controller: _fullname,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.drive_file_rename_outline),
                            //icon of text field
                            iconColor: Theme.of(context).iconTheme.color,
                            labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                                "WND_REGISTER_HINT_5",
                                "WND_REGISTER_HINT_5 ??"),
                            labelStyle: Theme.of(context).textTheme.titleSmall,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),

                        TextFormField(
                          controller: _username,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.alternate_email),
                            //icon of text field
                            iconColor: Theme.of(context).iconTheme.color,
                            labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                                "WND_REGISTER_HINT_2",
                                "WND_REGISTER_HINT_2 ??"),
                            labelStyle: Theme.of(context).textTheme.titleSmall,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                        TextFormField(
                          controller: _pass,
                          obscureText: bool.parse(Ref_Window
                              .Ref_Management.SETTINGS
                              .Get("WND_REGISTER_OBSTEXT_3", "true")),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password),
                            //icon of text field
                            iconColor: Theme.of(context).iconTheme.color,
                            labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                                "WND_REGISTER_HINT_3",
                                "WND_REGISTER_HINT_3 ??"),
                            labelStyle: Theme.of(context).textTheme.titleSmall,
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        /* CONFIRM THE PASSWORD, NOT REALLY NEEDED RIGHT?
                        TextFormField(
                          controller: _confirmPass,
                          obscureText: bool.parse(Ref_Window
                              .Ref_Management.SETTINGS
                              .Get("WND_REGISTER_OBSTEXT_3", "true")),
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.password_outlined),
                            iconColor: Theme.of(context).iconTheme.color,
                            //icon of text field
                            labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                                "WND_REGISTER_HINT_4",
                                "WND_REGISTER_HINT_4 ??"),
                            labelStyle: Theme.of(context).textTheme.titleSmall,
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

                         */
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            style: Theme.of(context).elevatedButtonTheme.style,
                            onPressed: () {
                              UtilsFlutter.MSG('HOME');
                              if (_formKey.currentState!.validate()) {
                                Utils.MSG_Debug("SIGNEDUP");
                                _signUp();
                              } // old method
                            },
                            child: Text(
                                Ref_Window.Ref_Management.SETTINGS.Get(
                                    "WND_REGISTER_BTN_1",
                                    "WND_REGISTER_BTN_1 ??"),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge // adicionar aqui isto Theme.of(context).secondaryHeaderColor,
                                ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

//--------------
  void _signUp() async {
    UserFirestore userFirestore = UserFirestore();

    String username = _username.text;
    String email = _email.text;
    String password = _pass.text;
    String fullname = _fullname.text;
    String currentTime = Utils.currentTimeUser();

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);
      String uid = user?.uid ?? ''; // Get the user ID

      // Now you can use the user ID as needed
      UserModel currentUser = UserModel(
          uid: uid,
          email: email,
          username: username,
          fullName: fullname,
          registerDate: currentTime,
          lastChangedDate: currentTime,
          location: '????');
      await userFirestore.saveUserData(currentUser);

      Ref_Window.Ref_Management.Delete_Shared_Preferences("EMAIL");
      Ref_Window.Ref_Management.Delete_Shared_Preferences("NAME");
      Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
          "NAME", currentUser.fullName);
      Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
          "EMAIL", currentUser.email);

      Utils.MSG_Debug("User is successfully created with ID: $uid");
      NavigateTo_Window_Home(context);
    } catch (e) {
      Utils.MSG_Debug("Error creating user: $e");
    }
  }

//--------------
//--------------
}
