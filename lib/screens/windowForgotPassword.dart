import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/appTheme.dart';
import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';

class windowForgotPassword extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  //--------------
  windowForgotPassword(this.Ref_Management) {
    windowTitle = "Register";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return _windowForgotPasswordState(this);
  }
}

class _windowForgotPasswordState extends State<windowForgotPassword> {
  final _emailController = TextEditingController();

  final windowForgotPassword Ref_Window;

  String className = "";

  //--------------
  _windowForgotPasswordState(this.Ref_Window) : super() {
    className = Ref_Window.Ref_Management.SETTINGS
        .Get("WND_FORGOT_PASSWORD_TITLE_1", "WND_REGISTER_HINT_1 ??");
    Utils.MSG_Debug("$className: createState");
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(Ref_Window.Ref_Management.SETTINGS.Get(
                "WND_FORGOT_PASSWORD_TITLE_2",
                "WND_FORGOT_PASSWORD_TITLE_2 ??")),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
            theme: provider.currentTheme,
            home: Scaffold(
              appBar: AppBar(),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        Ref_Window.Ref_Management.SETTINGS.Get(
                            "WND_FORGOT_PASSWORD_TITLE_2",
                            "WND_FORGOT_PASSWORD_TITLE_2 ??"),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),

                    SizedBox(height: 10),

                    //email textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Email',
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: passwordReset,
                        child: Text(
                            Ref_Window.Ref_Management.SETTINGS.Get(
                                "WND_FORGOT_PASSWORD_BTN_1_TEXT",
                                "WND_FORGOT_PASSWORD_BTN_1_TEXT ??"),
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                  ]),
            ));
      },
    );
  }
}
