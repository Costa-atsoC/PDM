import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubi/screens/windowInitial.dart';

import '../screens/windowSearch.dart';
import '../screens/windowSettings.dart';
import '../screens/windowUserProfile.dart';
import '../windowHome.dart';
import 'Management.dart';

class CustomDrawer extends StatefulWidget{
  final Management Ref_Management;

  CustomDrawer(this.Ref_Management);

  @override
  State<StatefulWidget> createState() {
    return State_CustomDrawer(this);
  }
}

class State_CustomDrawer extends State<CustomDrawer> {
  final CustomDrawer Ref_Window;
  String className = "";

  State_CustomDrawer(this.Ref_Window) : super() {
    className = "State_windowHome";
  }

  Future navigateToWindowSettings(context) async {
    windowSettings win = windowSettings(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowUserProfile(context) async {
    windowUserProfile win = windowUserProfile(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }


  Future navigateToWindowHome(context) async {
    windowHome win = windowHome(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowInitial(context) async {
    MyHomePage win = MyHomePage(Ref_Window.Ref_Management, Ref_Window.Ref_Management.GetDefinicao("TITULO_APP", "TITULO_APP ??"));
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/cover.jpg'),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30, // Tamanho do raio do círculo
                  backgroundImage:
                  AssetImage('assets/PORSCHE_MAIN_2.jpeg'),
                ),
                const SizedBox(height: 10),
                // Espaço entre a foto e o texto
                Text(
                  Ref_Window.Ref_Management.SETTINGS
                      .Get("WND_HOME_DRAWER_TITLE_1", "NAME"),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.input),
            // TODO meter o logo da app
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("JNL_HOME_DRAWER_SUBTITLE_1", "WELCOME"),
            ),
            // adicionar ao management
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowHome(context)},
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("JNL_HOME_DRAWER_SUBTITLE_2", "PROFILE"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowUserProfile(context)},
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("JNL_HOME_DRAWER_SUBTITLE_3", "SETTINGS"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowSettings(context)},
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("JNL_HOME_DRAWER_SUBTITLE_4", "FEEDBACK"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {Navigator.of(context).pop()},
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  child: ListTile(
                    // leading: Icon(Icons.exit_to_app),
                    // iconColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        Ref_Window.Ref_Management.SETTINGS
                            .Get("JNL_HOME_DRAWER_SUBTITLE_5", "LOGOUT"),
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer,
                        ),
                      ),
                    ),
                    onTap: () => {
                      Ref_Window.Ref_Management.Delete_Shared_Preferences(
                          "EMAIL"),
                      Ref_Window.Ref_Management.Delete_Shared_Preferences(
                          "NAME"),
                      FirebaseAuth.instance.signOut(),
                      Navigator.of(context).pop(),
                      navigateToWindowInitial(context)
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
