import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ubi/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:ubi/screens/windowInitial.dart';

import '../../firestore/user_firestore.dart';
import '../common/appTheme.dart';
import '../common/theme_provider.dart';
import '../common/widgets/RWMButtons.dart';
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
  bool selected = false;

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

  Widget createButtonTermsConditions() {
    double TAM = double.parse(
      Ref_Window.Ref_Management.GetDefinicao(
        "TAMANHO_TEXTO_BTN_NEW_REGISTER",
        "10",
      ),
    );

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
            return Theme.of(context)
                .scaffoldBackgroundColor; // defer to the defaults
          },
        ),
      ),
      onPressed: () {
        setState(() {
          selected = !selected;
          UtilsFlutter.MSG(
            Ref_Window.Ref_Management.GetDefinicao(
              "WND_REGISTER_TERMS_CONDITIONS",
              "Terms & Conditions",
            ), context,
          );

          // Show terms and conditions dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Terms and Conditions'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                            "WND_REGISTER_TERMS_CONDITIONS_TITLE_2",
                            'By using our carpooling service, you agree to the following terms and conditions:'),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                            "WND_REGISTER_TERMS_CONDITIONS_1",
                            '1. You must be at least 18 years old to use this app.'),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_2",
                          '2. Users are responsible for their own safety during rides.',
                        ),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                            "WND_REGISTER_TERMS_CONDITIONS_3",
                            '3. Respect other users and their personal space.'),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                            "WND_REGISTER_TERMS_CONDITIONS_4",
                            "4. Follow traffic laws and regulations during carpooling."),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_5",
                          '5. The app is not responsible for any disputes between users.',
                        ),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_6",
                          '6. Users are encouraged to report any inappropriate behavior.',
                        ),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_7",
                          '7. The app may use location data for the purpose of carpool matching.',
                        ),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_8",
                          '8. Users should verify the identity of their carpooling partners.',
                        ),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_9",
                          '9. The app may suspend or terminate users violating these terms.',
                        ),
                      ),
                      Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                          "WND_REGISTER_TERMS_CONDITIONS_10",
                          '10. By using the app, you consent to our privacy policy.',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text( Ref_Window.Ref_Management.SETTINGS.Get(
                      "WND_REGISTER_TERMS_CONDITIONS_BTN_1",
                      'Close',
                    ),),
                  ),
                ],
              );
            },
          );
        });
      },
      child: Text(
        Ref_Window.Ref_Management.GetDefinicao(
          "WND_REGISTER_TERMS_CONDITIONS",
          "Terms & Conditions",
        ),
        style: TextStyle(
          fontFamily: 'Lato',
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
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

    return Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
              theme: provider.currentTheme,
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/BACKGROUND_MOUNTAIN.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.9)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0),
                              child: Form(
                                key: _formKey,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(140),
                                        ),
                                        child: const CircleAvatar(
                                          radius: 100,
                                          backgroundColor:
                                              Color.fromARGB(0, 0, 0, 0),
                                          backgroundImage:
                                              AssetImage('assets/LOGO.png'),
                                        ),
                                      ),
                                      Text(Ref_Window
                                          .Ref_Management.SETTINGS
                                          .Get("WND_REGISTER_TITLE_1",
                                          "Create a RideWithME account"),
                                          style: TextStyle(
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.fontSize,
                                              fontWeight: FontWeight.bold)),
                                      Text(Ref_Window
                                          .Ref_Management.SETTINGS
                                          .Get("WND_REGISTER_SUBTITLE_1",
                                          "Start your journey Carpooling or being Carpooled now!"),
                                        style: TextStyle(
                                          fontSize: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.fontSize,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      TextFormField(
                                        controller: _email,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.email),
                                          //icon of text field
                                          iconColor:
                                              Theme.of(context).iconTheme.color,
                                          labelText: Ref_Window
                                              .Ref_Management.SETTINGS
                                              .Get("WND_REGISTER_HINT_1",
                                                  "WND_REGISTER_HINT_1 ??"),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 3.0,
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3.0,
                                            ),
                                          ),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        decoration: InputDecoration(
                                          icon: const Icon(
                                              Icons.drive_file_rename_outline),
                                          //icon of text field
                                          iconColor:
                                              Theme.of(context).iconTheme.color,
                                          labelText: Ref_Window
                                              .Ref_Management.SETTINGS
                                              .Get("WND_REGISTER_HINT_5",
                                                  "WND_REGISTER_HINT_5 ??"),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 3.0,
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3.0,
                                            ),
                                          ),
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        decoration: InputDecoration(
                                          icon:
                                              const Icon(Icons.alternate_email),
                                          //icon of text field
                                          iconColor:
                                              Theme.of(context).iconTheme.color,
                                          labelText: Ref_Window
                                              .Ref_Management.SETTINGS
                                              .Get("WND_REGISTER_HINT_2",
                                                  "WND_REGISTER_HINT_2 ??"),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 3.0,
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _pass,
                                        obscureText: bool.parse(Ref_Window
                                            .Ref_Management.SETTINGS
                                            .Get("WND_REGISTER_OBSTEXT_3",
                                                "true")),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        decoration: InputDecoration(
                                          icon: const Icon(Icons.password),
                                          //icon of text field
                                          iconColor:
                                              Theme.of(context).iconTheme.color,
                                          labelText: Ref_Window
                                              .Ref_Management.SETTINGS
                                              .Get("WND_REGISTER_HINT_3",
                                                  "WND_REGISTER_HINT_3 ??"),
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              width: 3.0,
                                            ),
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.blueAccent,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        validator: (String? value) {
                                          if (value == null || value.isEmpty) {
                                            return Ref_Window
                                                .Ref_Management.SETTINGS
                                                .Get(
                                                    "WND_REGISTER_PASSWORD_VALIDATOR_TEXT",
                                                    "Please enter some text");
                                          }
                                          return null;
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: ElevatedButton(
                                          style: Theme.of(context)
                                              .elevatedButtonTheme
                                              .style,
                                          onPressed: () {
                                            UtilsFlutter.MSG('HOME', context);
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //Utils.MSG_Debug("SIGNEDUP");
                                              _signUp();
                                            } // old method
                                          },
                                          child: Text(
                                              Ref_Window.Ref_Management.SETTINGS
                                                  .Get("WND_REGISTER_BTN_1",
                                                      "WND_REGISTER_BTN_1 ??"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge // adicionar aqui isto Theme.of(context).secondaryHeaderColor,
                                              ),
                                        ),
                                      ),
                                      Text(Ref_Window
                                          .Ref_Management.SETTINGS
                                          .Get("WND_REGISTER_TERMS_CONDITIONS_TITLE_1",
                                          "By creating an account, you are accepting the"),
                                         ),
                                      createButtonTermsConditions(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));});
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
        location: '????',
        image: 'assets/LOGO.png',
        online: '0',
        lastLogInDate: 'null',
        lastSignOutDate: 'null',
      );
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
