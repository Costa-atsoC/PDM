import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubi/common/Management.dart';
import 'package:ubi/screens/windowInitial.dart';

/*
FALTA APAGAR TODOS OS POSTS DESTE USER, TODOS OS SEUS LIKES, etc...
 */

class WindowDeleteAccount extends StatefulWidget {
  final Management refManagement;

  const WindowDeleteAccount(this.refManagement, {Key? key}) : super(key: key);

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
        await user.delete();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');

        // Navegar para MyHomePage após a exclusão da conta
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(widget.refManagement, 'Your Title'),
          ),
        );

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('User Account Deleted'),
        // ));

      } catch (e) {
        // Handle errors that occur during the process
        // For example, displaying an error message
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Delete Your Account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'This action is irreversible. Please enter your password to proceed.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                deleteAccount(_passwordController.text);
              },
              child: Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}
