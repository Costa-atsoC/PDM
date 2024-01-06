import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowForgotPassword.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/theme_provider.dart';
import '../common/widgets/RWMButtons.dart';
import '../firebase_auth_implementation/firebase_auth_services.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../firestore/firebase_storage.dart';
import '../main.dart';
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
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();

  bool? isChecked = false; // for the remember me checkbox (false default)

  String userID = "0"; // user id
  String rememberMeStatus = "0"; // default 0
  bool _dataLoaded = false;
  bool _hasImage = false;
  bool _isLoggedIn = false;

  List<UserModel> loadedUserProfiles = []; // STORING THE USER DATA
  List<Map<String, dynamic>> loadedImages = []; // STORING THE PROFILE IMAGES
  bool _isPasswordHidden = true; // hide the password

  @override
  void initState() {
    _loadUserData(); // need to change this :D can't have two functions with basically the same name, merge them!
    super.initState();
    Ref_Management.saveNumAccess("NUM_ACCESS_WND_LOGIN");
  }

  @override
  void dispose() {
    _pass.dispose();
    super.dispose();
  }

  @override
  void Load() {}

  bool selected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // _formKey
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final FirebaseAuthService _auth = FirebaseAuthService();

  Management Ref_Management;

  _MyHomePageState(this.Ref_Management);

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
              return Theme.of(context)
                  .scaffoldBackgroundColor; // defer to the defaults
            },
          ),
        ),
        onPressed: () {
          setState(
            () {
              selected = !selected;
              UtilsFlutter.MSG(
                  Ref_Management.GetDefinicao("TEXT_NEW_WINDOW_REGISTER",
                      "Accao-TEXT_NEW_WINDOW_REGISTER ??"),
                  context);
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
              color: Theme.of(context).colorScheme.onPrimary),
        ));
  }

  Widget Create_Button_Forgot_Password() {
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
            return Colors.transparent;
            // defer to the defaults
          },
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return windowForgotPassword(Ref_Management);
          }),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 10), // Adjust the spacing as needed
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return windowForgotPassword(Ref_Management);
                  }),
                );
              },
              child: Text(
                Ref_Management.GetDefinicao(
                    "WND_LOGIN_BTN_2", "Forgot Password?"),
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

  Future<void> _loadUserData() async {
    String? email = await Ref_Management.Get_SharedPreferences_STRING("EMAIL");
    String? uid = await Ref_Management.Get_SharedPreferences_STRING("UID");
    String? rememberStatus =
        await Ref_Management.Get_SharedPreferences_STRING("REMEMBER_ME_STATUS");
    String? rememberDate =
        await Ref_Management.Get_SharedPreferences_STRING("REMEMBER_ME_DATE");

    if (rememberStatus == "??" || rememberStatus == "0") {
      isChecked = false;
      rememberMeStatus = rememberStatus!;
    } else if (rememberStatus == "1") {
      isChecked = true;
      rememberMeStatus = rememberStatus!;
      if (email == "??") {
        _email.text = "";
      } else {
        _email.text = email!;
      }
    }

    userID = uid!;

    if (_dataLoaded) {
      return; // Skip fetching data if it's already loaded
    }
    try {
      //bool isLoggedIn = await checkIfLoggedIn();

      if (rememberStatus == "??" || rememberStatus == "0") {
        _isLoggedIn = false;
      } else if (rememberStatus == "1") {
        _isLoggedIn = true;
      }

      loadedImages.clear();

      // Load user data for the logged-in user
      UserModel? userProfile = await userFirestore.getUserData(userID);
      loadedUserProfiles.add(userProfile!);

      if (_isLoggedIn) {
        // Load user profile image
        List<Map<String, dynamic>> images =
            await Ref_FirebaseStorage.loadImages(userID);
        if (images.isNotEmpty) {
          Map<String, dynamic> firstImage = images.first;
          loadedImages.add(firstImage);
          _hasImage = true;
        }
        // If there are no images, use a default image URL from Firebase Storage
        else {
          _hasImage = false;
        }

        setState(() {
          _dataLoaded = true; // Set the flag to true after loading data
        });
      } else {
        _hasImage = false;

        setState(() {
          _dataLoaded = true; // Set the flag to true after loading data
        });
      }
    } catch (e) {
      Utils.MSG_Debug("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        theme: provider.currentTheme,
        home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                      child: Center(
                        child: Container(
                          margin:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(140),
                                  ),
                                  child: Expanded(
                                    child: _dataLoaded
                                        ? (_hasImage && _isLoggedIn
                                            ? SizedBox(
                                                width: 200,
                                                height: 200,
                                                child: CircleAvatar(
                                                  radius: 100,
                                                  backgroundImage: NetworkImage(
                                                      loadedImages[0]['url']),
                                                ),
                                              )
                                            : const SizedBox(
                                                width: 200,
                                                height: 200,
                                                child: CircleAvatar(
                                                  radius: 100,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  backgroundImage: AssetImage(
                                                      "assets/LOGO.png"),
                                                ),
                                              ))
                                        : Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  height:
                                      20, // meter isto responsivo e meter no management
                                ),
                                // aqui meter um Text que diz welcome back caso o user tenha o seu UID nas preferencias
                                Text(
                                  _dataLoaded && _isLoggedIn
                                      ? "${Ref_Management.SETTINGS.Get("WND_LOGIN_TITLE_1_TEXT_LOGGED", "Welcome back, ")}${loadedUserProfiles[0].fullName}!"
                                      : Ref_Management.SETTINGS.Get(
                                          "WND_LOGIN_TITLE_1_TEXT",
                                          "Greetings! Welcome to RideWithME!"),
                                  style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.fontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.fontSize,
                                  ),
                                  textAlign: TextAlign.center,
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
                                        .Get("WND_LOGIN_HINT_1", "Email"),
                                    labelStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width:
                                              3.0), // Set the border color here
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent,
                                          width:
                                              3.0), // Set the border color here
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.titleSmall,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return Ref_Management.SETTINGS.Get(
                                          "WND_LOGIN_HINT_1_WARNING",
                                          "Please enter your email");
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: _pass,
                                  obscureText: _isPasswordHidden,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.password_outlined),
                                    labelText: Ref_Management.SETTINGS.Get(
                                        "WND_LOGIN_HINT_2",
                                        "WND_LOGIN_HINT_2 ??"),
                                    labelStyle:
                                        Theme.of(context).textTheme.titleSmall,
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 3.0,
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blueAccent,
                                        width: 3.0,
                                      ),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordHidden =
                                              !_isPasswordHidden;
                                        });
                                      },
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.titleSmall,
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return Ref_Management.SETTINGS.Get(
                                          "WND_LOGIN_HINT_2_WARNING",
                                          "Please enter your password 2");
                                    }
                                    return null;
                                  },
                                ),
                                Row(children: [
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Checkbox(
                                            tristate: false,
                                            value: isChecked,
                                            activeColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            // Set the color you want
                                            onChanged: (bool? value) {
                                              if (value != null) {
                                                setState(() {
                                                  isChecked = value;
                                                });
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Text(Ref_Management.SETTINGS.Get(
                                          "WND_LOGIN_CHECKBOX_LABEL_1",
                                          "Remember Me"))
                                    ],
                                  ),
                                  const Spacer(),
                                  Create_Button_Forgot_Password(),
                                ]),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _signIn();
                                      if (_formKey.currentState!.validate()) {
                                      } else {
                                        Utils.MSG_Debug("ERROR");
                                      }
                                    },
                                    child: Text(
                                        Ref_Management.SETTINGS.Get(
                                            "WND_LOGIN_BTN_1",
                                            "WND_LOGIN_BTN_1 ??"),
                                        style: Theme.of(context)
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
            ),
          ),
        ),
      );
    });
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
      Ref_Management.Save_Shared_Preferences_STRING("EMAIL", email);

      /// always handy saving the user id
      Utils.MSG_Debug("${user!.uid} is logged in");

      /// now, instead of saving the user and updating him this way, i've created a function that gets his data
      /// in a json format (mandatory) and updates him through a function (gen. function) given the online attribute
      /// and the value
      // UserModel? userData = await userFirestore.getUserData(user.uid); old method
      String? userDataJson = await userFirestore.getUserDataJson(user.uid);
      Ref_Management.Save_Shared_Preferences_STRING(
          "USER_DATA_JSON", userDataJson!);
      String? userDataJsonSharedPrefs =
          await Ref_Management.Get_SharedPreferences_STRING("USER_DATA_JSON");
      Utils.MSG_Debug(userDataJsonSharedPrefs!);

      if (userDataJson != null) {
        UserModel? userData = UserModel.fromJson(jsonDecode(userDataJson));
        Utils.MSG_Debug(userDataJson);

        if (userData != null) {
          // Use userModel as needed
          Utils.MSG_Debug("User ID: ${userData.uid}");
          Utils.MSG_Debug("Username: ${userData.username}");

          userFirestore.updateUserAttribute(user.uid, "online", "1");
          userFirestore.updateUserAttribute(
              user.uid, "lastLogInDate", currentTime);
        } else {
          Utils.MSG_Debug("Failed to convert JSON to UserModel");
        }
      } else {
        Utils.MSG_Debug("User data JSON is null");
      }

      /// Old method to update the user
      /*
      UserModel userUpdated = UserModel(
        uid: userData.uid,
        email: userData.email,
        username: userData.username,
        fullName: userData.fullName,
        registerDate: userData.registerDate,
        lastChangedDate: userData.lastChangedDate,
        location: userData.location,
        image: userData.image,
        online: "1",
        lastLogInDate: currentTime,
        lastSignOutDate: userData!.lastSignOutDate,
      );
      userFirestore.updateUserData(userUpdated);

       */

      if (isChecked!) {
        if (await Ref_Management.Get_SharedPreferences_STRING(
                "REMEMBER_ME_DATE") ==
            "??") {
          Ref_Management.Save_Shared_Preferences_STRING(
              "REMEMBER_ME_DATE", Utils.currentTimeUser());
          Ref_Management.Save_Shared_Preferences_STRING(
              "REMEMBER_ME_STATUS", "1");
        } else {
          Ref_Management.Save_Shared_Preferences_STRING(
              "REMEMBER_ME_STATUS", "1");
        }
      } else {
        Ref_Management.Save_Shared_Preferences_STRING(
            "REMEMBER_ME_STATUS", "0");
      }
      /*
      Ref_Management.Save_Shared_Preferences_STRING("NAME", userData.fullName);
      Ref_Management.Save_Shared_Preferences_STRING("EMAIL", userData.email);
      Ref_Management.Save_Shared_Preferences_STRING("USERNAME", userData.username);
      Ref_Management.Save_Shared_Preferences_STRING("LOCATION", userData.location);
      Ref_Management.Save_Shared_Preferences_STRING("REGDATE", userData.registerDate);
      Ref_Management.Save_Shared_Preferences_STRING("LASTDATE", userData.lastChangedDate);
      Ref_Management.Save_Shared_Preferences_STRING("IMAGE", userData.image);
      Ref_Management.Save_Shared_Preferences_STRING("LOGINDATE", userData.lastLogInDate);
      Ref_Management.Save_Shared_Preferences_STRING("LOGINDATE_FORMATED", Utils.currentTimeUser());
      Ref_Management.Save_Shared_Preferences_STRING("SIGNOUTDATE", userData.lastSignOutDate);
       */

      Ref_Management.saveNumAccess(
          "NUM_ACCESS_LOGIN"); // guardar o numero de vezes que dá login

      //Utils.MSG_Debug("User is signed");
      // saving the email! in the shared_preferences

      //else if(Ref_Management.Get_SharedPreferences_STRING("TIME_EMAIL") == "??") aqui implementar a logica para comparar as datas do login
      NavigateTo_Window_Home(context);
      _email.clear();
      _pass.clear();
    } catch (e) {
      // In case the user puts a wrong email or password
      Utils.MSG_Debug("Sign-in failed: $e");
      UtilsFlutter.MSG('Invalid email or password', context);
    }
  }
}
