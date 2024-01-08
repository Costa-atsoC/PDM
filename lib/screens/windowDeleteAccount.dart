import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubi/common/Management.dart';
import 'package:ubi/screens/windowInitial.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';
import '../firestore/user_firestore.dart';

class WindowDeleteAccount extends StatefulWidget {
  final Management Ref_Management;

  const WindowDeleteAccount(this.Ref_Management, {Key? key}) : super(key: key);

  @override
  State<WindowDeleteAccount> createState() => _WindowDeleteAccountState();
}

class _WindowDeleteAccountState extends State<WindowDeleteAccount> {
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void deleteAccount(String password) async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );

        await user.reauthenticateWithCredential(credential);
        await UserFirestore().deleteUserData(user.uid);
        await user.delete();

        widget.Ref_Management.Delete_Shared_Preferences('EMAIL');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              widget.Ref_Management,
              widget.Ref_Management.GetDefinicao(
                "WND_HOME_TITLE",
                "Your Title",
              ),
            ),
          ),
        );

      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.Ref_Management.GetDefinicao(
            "WND_DELETE_ACCOUNT_TITLE",
            "Delete Account",
          ),
          style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.Ref_Management.GetDefinicao(
                "WND_DELETE_ACCOUNT_WARNING",
                'This action is irreversible. Please enter your password to proceed.',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: widget.Ref_Management.GetDefinicao(
                  "WND_DELETE_ACCOUNT_PASSWORD",
                  'Password',
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                deleteAccount(_passwordController.text);
              },
              child: Text(
                widget.Ref_Management.GetDefinicao(
                  "WND_DELETE_ACCOUNT_BUTTON",
                  'Delete Account',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}