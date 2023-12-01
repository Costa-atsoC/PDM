import 'package:flutter/material.dart';
import 'package:ubi/common/appTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ubi/screens/windowInitial.dart';
import 'package:ubi/windowHome.dart';

import 'firebase_options.dart';
import 'common/Management.dart';
import 'common/Utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

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

@override
class MyApp extends StatelessWidget {
  const MyApp({Key? key});


  @override
  Widget build(BuildContext context) {
    Management appManagement = Management("APP-RideWME");
    appManagement.Load();

    return FutureBuilder<bool>(
      future: checkInternetConnection(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator while checking internet connection
        } else {
          Widget initialScreen;

          String logged = appManagement.GetDefinicao("USERNAME", "null");

          //We are checking if the user has internet connection and if the user is logged in or not
          if (snapshot.hasData && snapshot.data!) {
            if (logged != "null") {
              initialScreen = windowHome(appManagement);
            } else {
              initialScreen = MyHomePage(appManagement, appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??"));
            }
          } else {
            initialScreen = MyHomePage(appManagement, appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??"));
          }

          return MaterialApp(
            title: 'RideWME',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: initialScreen,
          );
        }
      },
    );
  }
}
