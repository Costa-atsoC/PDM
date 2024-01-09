import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ubi/screens/windowDeleteAccount.dart';
import 'package:ubi/screens/windowsLanguage.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../main.dart';
import 'windowChangePassword.dart';
import 'windowAppearance.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/theme_provider.dart';
import 'package:provider/provider.dart';
import 'windowInitial.dart';

class windowSettings extends StatefulWidget {
  final Management Ref_Management;
  String windowTitle = "";

  windowSettings(this.Ref_Management) {
    windowTitle = Ref_Management.GetDefinicao("WND_SETTINGS_TITLE", "General Window");
    Utils.MSG_Debug(windowTitle);
  }

  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
  }

  @override
  State<StatefulWidget> createState() {
    return State_windowSettings();
  }

  Future<void> navigateToWindowInitial(BuildContext context) async {
    MyHomePage win = MyHomePage(
        Ref_Management,
        Ref_Management.GetDefinicao(
            "TITULO_APP", "TITULO_APP ??"));
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }
}

class State_windowSettings extends State<windowSettings> {
  late List<String> _options;

  IconData getOptionIcon(String title) {
    switch (title) {
      case 'Change Password':
        return Icons.lock;
      case 'Appearance':
        return Icons.palette;
      case 'Language':
        return Icons.language;
      case 'Delete Account':
        return Icons.delete;
      case 'Delete Cache':
        return Icons.delete_outline;
      case 'Terms & Conditions':
        return Icons.assignment; // Ícone para a opção "Terms & Conditions"
      default:
        return Icons.error; // Ícone padrão para opções desconhecidas
    }
  }


  @override
  void dispose() {
    Utils.MSG_Debug("dispose");
    super.dispose();
    Utils.MSG_Debug("dispose:dispose");
  }

  @override
  void deactivate() {
    Utils.MSG_Debug("dispose:deactivate");
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("dispose: didChangeDependencies");
    super.didChangeDependencies();
  }

  @override  @override
  void initState() {
    super.initState();
    _options = [
      widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_CHANGE_PASSWORD", "Change Password"),
      widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_APPEARANCE", "Appearance"),
      widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_LANGUAGE", "Language"),
      widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_DELETE_ACCOUNT", "Delete Account"),
      widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_DELETE_CACHE", "Delete Cache"),
      widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_TERMS_CONDITIONS", "Terms & Conditions"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          theme: provider.currentTheme,
          home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                widget.Ref_Management.GetDefinicao("WND_SETTINGS_TITLE", "Settings"),
                style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onPrimary),
              ),
              centerTitle: true,
            ),
            body: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 40),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 10),
                            Text(
                              widget.Ref_Management.GetDefinicao("WND_SETTINGS_ACCOUNT", "Account"),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(height: 20, thickness: 1),
                        SizedBox(height: 20),
                        for (var option in _options)
                          buildAccountOption(context, option),
                      ],
                    ),
                  ), // Espaçamento entre a lista e o botão de logout
                  buildLogoutContainer(context),
                  SizedBox(height: 220),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == 'Change Password' || title == 'Alterar Palavra-passe' || title == 'Passwort ändern') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WindowChangePassword(widget.Ref_Management),
            ),
          );
        } else if (title == 'Appearance' || title == 'Aparência' || title == 'Aussehen') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WindowAppearance(widget.Ref_Management),
            ),
          );
        } else if (title == 'Delete Account' || title == 'Apagar Conta' || title == 'Konto löschen') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WindowDeleteAccount(widget.Ref_Management),
            ),
          );
        } else if (title == 'Language' || title == 'Idioma' || title == 'Sprache') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WindowLanguage(widget.Ref_Management),
            ),
          );
        } else if (title == 'Delete Cache' || title == 'Apagar Cache' || title == 'Cache löschen') {
          _showConfirmationDialog(context);
        }
        else if (title == 'Terms & Conditions' || title == 'Termos e Condições' || title == 'Geschäftsbedingungen') {
          _showTermsAndConditionsDialog(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  getOptionIcon(title),
                  size: 24,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.Ref_Management.GetDefinicao(
                "WND_SETTINGS_CLEAR_PREF_TITLE",
                'Clear All Preferences'
            ),
          ),
          content: Text(
            widget.Ref_Management.GetDefinicao(
                "WND_SETTINGS_CLEAR_PREF_CONTENT",
                'Are you sure you want to clear all preferences?'
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                widget.Ref_Management.GetDefinicao(
                    "WND_SETTINGS_CLEAR_PREF_CANCEL",
                    'Cancel'
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await widget.Ref_Management.clearAllSharedPreferences();
                Navigator.of(context).pop();
              },
              child: Text(
                widget.Ref_Management.GetDefinicao(
                    "WND_SETTINGS_CLEAR_PREF_CLEAR",
                    'Clear'
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildLogoutContainer(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(
            color: Theme
                .of(context)
                .colorScheme
                .secondaryContainer,
          ),
        ),
        color: Theme
            .of(context)
            .colorScheme
            .secondaryContainer,
        child: ListTile(
          title: Align(
            child: Text(
              widget.Ref_Management.GetDefinicao("WND_SETTINGS_OPTION_LOGOUT", "Logout"),
              textAlign: TextAlign.center,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(),
            ),
          ),
          onTap: () async {
            UserModel? userData = await userFirestore
                .getUserData(FirebaseAuth.instance.currentUser!.uid);
            UserModel userUpdated = UserModel(
              uid: userData!.uid,
              email: userData!.email,
              username: userData!.username,
              fullName: userData!.fullName,
              registerDate: userData!.registerDate,
              lastChangedDate: userData!.lastChangedDate,
              location: userData!.location,
              image: userData!.image,
              online: "0",
              lastLogInDate: userData!.lastLogInDate,
              lastSignOutDate: Utils.currentTime(),
            );

            if (userData != null) {
              await userFirestore.updateUserData(userUpdated);
            }

            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pop();
            widget.navigateToWindowInitial(context);
          },
        ),
      ),
    );
  }

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                      "WND_REGISTER_TERMS_CONDITIONS_TITLE_2",
                      'By using our carpooling service, you agree to the following terms and conditions:'),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                      "WND_REGISTER_TERMS_CONDITIONS_1",
                      '1. You must be at least 18 years old to use this app.'),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_2",
                    '2. Users are responsible for their own safety during rides.',
                  ),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                      "WND_REGISTER_TERMS_CONDITIONS_3",
                      '3. Respect other users and their personal space.'),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                      "WND_REGISTER_TERMS_CONDITIONS_4",
                      "4. Follow traffic laws and regulations during carpooling."),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_5",
                    '5. The app is not responsible for any disputes between users.',
                  ),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_6",
                    '6. Users are encouraged to report any inappropriate behavior.',
                  ),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_7",
                    '7. The app may use location data for the purpose of carpool matching.',
                  ),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_8",
                    '8. Users should verify the identity of their carpooling partners.',
                  ),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_9",
                    '9. The app may suspend or terminate users violating these terms.',
                  ),
                ),
                Text(
                  widget.Ref_Management.SETTINGS.Get(
                    "WND_REGISTER_TERMS_CONDITIONS_10",
                    '10. By using the app, you consent to our privacy policy.',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(widget.Ref_Management.SETTINGS.Get(
                "WND_REGISTER_TERMS_CONDITIONS_BTN_1",
                'Close',
              ),
              ),
            ),
          ],
        );
      },
    );
  }
}
