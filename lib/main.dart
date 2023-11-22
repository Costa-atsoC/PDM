import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubi/common/appTheme.dart';
import 'package:ubi/screens/windowInitial.dart';
import 'firebase_auth_implementation/firebase_auth_services.dart';
import 'windowGeneral.dart';
import 'windowRegister.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'Management.dart';
import 'windowHome.dart';
import 'Utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Management appManagement = Management("APP-RideWME");
    appManagement.Load();
    return MaterialApp(
      title: 'RideWME',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MyHomePage(appManagement,
          appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??")),
    );
  }
}