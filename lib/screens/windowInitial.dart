import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowForgotPassword.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/widgets/RWMButtons.dart';
import '../firebase_auth_implementation/firebase_auth_services.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../windowHome.dart';
import 'windowRegister.dart';

class MyHomePage extends StatefulWidget {
  Management Ref_Management;

  MyHomePage(this.Ref_Management, this.title);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(Ref_Management);

  Load() {}
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _pass.dispose();

    super.dispose();
  }

  @override
  void Load(){

  }

  bool selected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // _formKey
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  final FirebaseAuthService _auth = FirebaseAuthService();

  int _counter = 0;
  Management Ref_Management;

  _MyHomePageState(this.Ref_Management);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget Create_Button_New_Window_Register() {
    double TAM = double.parse(
        Ref_Management.GetDefinicao("TAMANHO_TEXTO_BTN_NEW_REGISTER", "10"));
    return SelectableButton(
        selected: selected,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return null; // defer to the defaults
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return Theme
                  .of(context)
                  .scaffoldBackgroundColor; // defer to the defaults
            },
          ),
        ),
        onPressed: () {
          setState(
                () {
              selected = !selected;
              UtilsFlutter.MSG(Ref_Management.GetDefinicao(
                  "TEXT_NEW_WINDOW_REGISTER",
                  "Accao-TEXT_NEW_WINDOW_REGISTER ??"));
              NavigateTo_Window_Register(context);
            },
          );
        },
        child: Text(
          Ref_Management.GetDefinicao(
              "TEXT_OF_BUTTON_REGISTER", "TEXT_NEW_WINDOW_REGISTER ??"),
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme
                  .of(context)
                  .colorScheme
                  .onPrimary),
        ));
  }

  Widget Create_Button_Forgot_Password() {
    double TAMButtonRegister = double.parse(
        Ref_Management.GetDefinicao("TAMANHO_TEXTO_BTN_NEW_REGISTER", "10"));
    double TAMButtonForgotPassword = double.parse(
        Ref_Management.GetDefinicao("SIZE_TEXT_BUTTON_FORGOT_PASSWORD", "10"));

    return SelectableButton(
      selected: selected,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return null; // defer to the defaults
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.white;
            }
            return Theme.of(context).scaffoldBackgroundColor;
            // defer to the defaults
          },
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return windowForgotPassword();
          }),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 10), // Adjust the spacing as needed
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return windowForgotPassword();
                  }),
                );
              },
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -----------------------------------
  ///            WINDOW FUNCTIONS
  /// -----------------------------------
  //--------- Janela Register
  Future NavigateTo_Window_Register(context) async {
    windowRegister win = new windowRegister(Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------- Janela Home
  Future NavigateTo_Window_Home(context) async {
    windowHome Jan = windowHome(Ref_Management);
    await Jan.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Jan));
  }

  Future<void> _initializeData() async {
    // Ref_Management.Save_Shared_Preferences_STRING("EMAIL", "email");
    //print("_initializeData.......................................................");
    String? email = await Ref_Management.Get_SharedPreferences_STRING("EMAIL");
    String? uid = await Ref_Management.Get_SharedPreferences_STRING("UID");
    print(uid);
    if (email == "??") {
      _email.text = "";
    } else {
      _email.text = email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(140),
                          ),
                          child: const CircleAvatar(
                            radius: 100,
                            backgroundColor: Color.fromARGB(0, 0, 0, 0),
                            backgroundImage: AssetImage('assets/LOGO.png'),
                          ),
                        ),
                        const SizedBox(
                          height:
                          40, // meter isto responsivo e meter no management
                        ),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            icon: Icon(Icons.alternate_email),
                            labelText: Ref_Management.SETTINGS
                                .Get("WND_LOGIN_HINT_10", "Email"),
                            labelStyle: Theme
                                .of(context)
                                .textTheme
                                .titleSmall,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3.0), // Set the border color here
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 3.0), // Set the border color here
                            ),
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _pass,
                          obscureText: bool.parse(Ref_Management.SETTINGS
                              .Get("WND_REGISTER_OBSTEXT_3", "true")),
                          decoration: InputDecoration(
                            icon: Icon(Icons.password_outlined),
                            labelText: Ref_Management.SETTINGS
                                .Get("WND_LOGIN_HINT_2", "WND_LOGIN_HINT_2 ??"),
                            labelStyle: Theme
                                .of(context)
                                .textTheme
                                .titleSmall,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3.0), // Set the border color here
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blueAccent,
                                  width: 3.0), // Set the border color here
                            ),
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Create_Button_Forgot_Password(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _signIn();
                              if (_formKey.currentState!.validate()) {} else {
                                Utils.MSG_Debug("ERROR");
                              }
                            },
                            child: Text(
                                Ref_Management.SETTINGS.Get(
                                    "WND_LOGIN_BTN_1", "WND_LOGIN_BTN_1 ??"),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .titleLarge),
                          ),
                        ),
                        Create_Button_New_Window_Register(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //--------------
  void _signIn() async {
    UserFirestore userFirestore = UserFirestore();

    // String username = _username.text;
    String email = _email.text;
    String password = _pass.text;
    String currentTime = Utils.currentTime();

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);
      Ref_Management.Save_Shared_Preferences_STRING("UID", user!.uid);

      UserModel? userData = await userFirestore.getUserData(user.uid);
      Ref_Management.Save_Shared_Preferences_STRING("NAME", userData!.fullName);
      Ref_Management.Save_Shared_Preferences_STRING("EMAIL", userData.email);
      Ref_Management.Save_Shared_Preferences_STRING("USERNAME", userData.username);
      Ref_Management.Save_Shared_Preferences_STRING("LOCATION", userData.location);
      Ref_Management.Save_Shared_Preferences_STRING("REGDATE", userData.registerDate);
      Ref_Management.Save_Shared_Preferences_STRING("LASTDATE", userData.lastChangedDate);
      Ref_Management.Save_Shared_Preferences_STRING("IMAGE", userData.image);

      Utils.MSG_Debug("User is signed");
      // saving the email! in the shared_preferences
      Ref_Management.Save_Shared_Preferences_STRING("TIME_EMAIL", currentTime);

      //else if(Ref_Management.Get_SharedPreferences_STRING("TIME_EMAIL") == "??") aqui implementar a logica para comparar as datas do login
      NavigateTo_Window_Home(context);
      _email.clear();
      _username.clear();
      _pass.clear();
    } catch (e) {
      // In case the user puts a wrong email or password
      Utils.MSG_Debug("Sign-in failed: $e");
      UtilsFlutter.MSG('Invalid email or password');
    }
  }
}