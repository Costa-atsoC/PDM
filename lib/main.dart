import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubi/common/appTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowInitial.dart';
import 'package:ubi/windowHome.dart';

import 'firebase_auth_implementation/models/user_model.dart';
import 'firebase_options.dart';
import 'common/Management.dart';
import 'common/Utils.dart';

final UserFirestore userFirestore = UserFirestore();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);

  try {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    });
  } catch (err) {
    // Error getting token.
  }

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);
  runApp(const MyApp());
}

Future<bool> checkInternetConnection() async {
  return await UtilsFlutter.checkInternetConnection();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});
  @override
  Widget build(BuildContext context) {
    Management appManagement = Management("APP-RideWME");

    return FutureBuilder<bool>(
      future: checkInternetConnection(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Simulate a delay of 2 seconds (adjust as needed)
          return FutureBuilder<void>(
            future: Future.delayed(Duration(seconds: 20)),
            builder: (BuildContext context, AsyncSnapshot<void> delaySnapshot) {
              if (delaySnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                if(appManagement.Get_SharedPreferences_STRING("LANGUAGE") == null){
                  appManagement.Save_Shared_Preferences_STRING("LANGUAGE", "EN");
                }
                if(appManagement.Get_SharedPreferences_STRING("THEME") == null){
                  appManagement.Save_Shared_Preferences_STRING("THEME", "DARK");
                }
                appManagement.Load();
                // Continue with your logic after the delay
                Widget initialScreen = MyHomePage(
                  appManagement,
                  appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??"),
                );

                return MaterialApp(
                  title: 'RideWME',
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  home: MyAppWrapper(
                    initialScreen: initialScreen,
                    appManagement: appManagement,
                  ),
                );
              }
            },
          );
        } else {
          if(appManagement.Get_SharedPreferences_STRING("LANGUAGE") == "??"){
            appManagement.Save_Shared_Preferences_STRING("LANGUAGE", "PT");
          }
          if(appManagement.Get_SharedPreferences_STRING("THEME") == null){
            appManagement.Save_Shared_Preferences_STRING("THEME", "DARK");
          }
          appManagement.Load();

          Widget initialScreen = MyHomePage(
            appManagement,
            appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??"),
          );

          return MaterialApp(
            title: 'RideWME',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: MyAppWrapper(
              initialScreen: initialScreen,
              appManagement: appManagement,
            ),
          );
        }
      },
    );
  }
}

class MyAppWrapper extends StatefulWidget {
  final Widget initialScreen;
  final Management appManagement;

  const MyAppWrapper(
      {Key? key, required this.initialScreen, required this.appManagement})
      : super(key: key);

  @override
  _MyAppWrapperState createState() => _MyAppWrapperState();
}

class _MyAppWrapperState extends State<MyAppWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Use Future.microtask to schedule the asynchronous operation
    Future.microtask(() async {
      // Check if currentUser is not null before accessing uid
      if (FirebaseAuth.instance.currentUser != null) {
        UserModel? user = await userFirestore.getUserData(FirebaseAuth.instance.currentUser!.uid);
        if (user != null) {
          userFirestore.updateUserOnline(user, true);
        }
      }
    });
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // this method knows when the user leaves the app (background, exit, etc...) and updates his online/offline state
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      UserModel? user = await userFirestore
          .getUserData(FirebaseAuth.instance.currentUser!.uid);
      if (user != null) {
        await userFirestore.updateUserOnline(user, true);
        /*
        Utils.MSG_Debug("UPDATING TO ONLINE");
        Utils.MSG_Debug("UPDATING TO ONLINE");
        Utils.MSG_Debug("UPDATING TO ONLINE");
        Utils.MSG_Debug("UPDATING TO ONLINE");
        Utils.MSG_Debug("UPDATING TO ONLINE");
        WORKING!
         */
      }
    } else {
      UserModel? user = await userFirestore
          .getUserData(FirebaseAuth.instance.currentUser!.uid);
      if (user != null) {
        await userFirestore.updateUserOnline(user, false);
        /*
        Utils.MSG_Debug("UPDATING TO OFFLINE");
        Utils.MSG_Debug("UPDATING TO OFFLINE");
        Utils.MSG_Debug("UPDATING TO OFFLINE");
        Utils.MSG_Debug("UPDATING TO OFFLINE");
        Utils.MSG_Debug("UPDATING TO OFFLINE");
        WORKING!
         */
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.initialScreen;
  }
}
