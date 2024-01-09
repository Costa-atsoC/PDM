import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ubi/screens/windowInitial.dart';
import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';

class WindowChangePassword extends StatefulWidget {
  final Management Ref_Management;

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

  late final Management Ref_Management;

  _WindowChangePasswordState(this.Ref_Management);

  late final WindowChangePassword Ref_Window;

  @override
  void initState() {
    super.initState();
    currentUser = auth.currentUser!;
    Ref_Window = WindowChangePassword(Ref_Management);
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future navigateToWindowHome(context) async {
    MyHomePage win = MyHomePage(
        Ref_Window.Ref_Management,
        Ref_Window.Ref_Management.GetDefinicao(
            "TITULO_APP", "TITULO_APP ??"));
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
      print("Password Changed");
    } catch (error) {
      print("Error updating password: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Ref_Window.Ref_Management.GetDefinicao(
              "WND_CHANGE_PASSWORD_TITLE", "Change Password"),
          style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: oldPasswordController,
              decoration: InputDecoration(
                labelText: Ref_Window.Ref_Management.GetDefinicao(
                    "WND_CHANGE_PASSWORD_OLD_PASSWORD", "Old Password"),
                hintText: Ref_Window.Ref_Management.GetDefinicao(
                    "WND_CHANGE_PASSWORD_OLD_PASSWORD_HINT", "* * * * * *"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: newPasswordController,
              decoration: InputDecoration(
                labelText: Ref_Window.Ref_Management.GetDefinicao(
                    "WND_CHANGE_PASSWORD_NEW_PASSWORD", "New Password"),
                hintText: Ref_Window.Ref_Management.GetDefinicao(
                    "WND_CHANGE_PASSWORD_NEW_PASSWORD_HINT", "* * * * * *"),
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
              child: Text(
                Ref_Window.Ref_Management.GetDefinicao(
                    "WND_CHANGE_PASSWORD_BUTTON", "Change Password and Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}