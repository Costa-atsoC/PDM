import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubi/screens/windowInitial.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/theme_provider.dart';

class WindowChangePassword extends StatefulWidget {
  Management Ref_Management;

  WindowChangePassword(this.Ref_Management);

  @override
  State<WindowChangePassword> createState() =>
      _WindowChangePasswordState(Ref_Management);
}

class _WindowChangePasswordState extends State<WindowChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  late User currentUser;

  late final WindowChangePassword Ref_Window;

  _WindowChangePasswordState(Management Ref_Management);

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser!;
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future navigateToWindowHome(context) async {
    MyHomePage win = MyHomePage(Ref_Window.Ref_Management,
        Ref_Window.Ref_Management.GetDefinicao("TITULO_APP", "TITULO_APP ??"));
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  void changePassword(
      {required String oldPassword, required String newPassword}) async {
    final cred = EmailAuthProvider.credential(
      email: currentUser.email!,
      password: oldPassword,
    );

    try {
      await currentUser.reauthenticateWithCredential(cred);
      await currentUser.updatePassword(newPassword);
      await auth.signOut();
      // NavigateTo_Window_Login(context);// Faz logout após a alteração da senha
      print("Password Changed and Signed out");
    } catch (error) {
      print("Error updating password: $error");
    }
  }

/*
  Future NavigateTo_Window_Login(context) async {
    windowInitial win = new windowInitial(Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }
 */

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
          theme: provider.currentTheme,
          home: Scaffold(
            appBar: AppBar(
              title: const Text("Change Password & Logout"),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: oldPasswordController,
                    decoration: const InputDecoration(
                      isDense: true,
                      alignLabelWithHint: true,
                      labelText: "Old Password",
                      hintText: "* * * * * *",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "New Password",
                      hintText: "* * * * * *",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      changePassword(
                        oldPassword: oldPasswordController.text,
                        newPassword: newPasswordController.text,
                      );
                      Utils.MSG_Debug("TESTE EMAIL LOGGOUT CHANGE PASSWORD");
                      navigateToWindowHome(context);
                    },
                    child: const Text("Change Password and Logout"),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
