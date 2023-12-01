import 'package:flutter/material.dart';
import 'package:ubi/common/appTheme.dart';
import 'package:ubi/screens/windowInitial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'common/Management.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Management appManagement = Management("APP-RideWME");
    appManagement.Load();
    return MaterialApp(
      title: 'RideWME',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MyHomePage(appManagement, appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??")),
    );
  }
}
