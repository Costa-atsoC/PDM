import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/main.dart';
import 'package:ubi/screens/windowInitial.dart';

import '../firebase_auth_implementation/models/user_model.dart';
import '../firestore/firebase_storage.dart';
import '../screens/windowFeedback.dart';
import '../screens/windowSettings.dart';
import '../screens/windowUserProfile.dart';
import '../windowHome.dart';
import 'Management.dart';
import 'Utils.dart';

class CustomDrawer extends StatefulWidget {
  final Management Ref_Management;
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();
  final UserFirestore userFirestore = UserFirestore();

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

  @override
  void initState() {
    _loadUserImage();
    super.initState();
  }

  bool _dataLoaded = true;
  bool _hasImage = false;
  List<Map<String, dynamic>> loadedImages = [];

  Future<void> _loadUserImage() async {
    /*
    String? uid = await Ref_Window.Ref_Management.Get_SharedPreferences_STRING("UID");

    // Skip fetching data if it's already loaded
    if (_dataLoaded) {
      return;
    }

    try {
      loadedImages.clear();

      List<Map<String, dynamic>> images = await Ref_Window.Ref_FirebaseStorage.loadImages(uid!);

      if (images.isNotEmpty) {
        Map<String, dynamic> firstImage = images.first;
        loadedImages.add(firstImage);
        _hasImage = true;
      } else {
        _hasImage = false;
      }
    } catch (e) {
      Utils.MSG_Debug("Error fetching user data: $e");
    } finally {
      setState(() {
        _dataLoaded = true; // Set the flag to true after loading data
      });
    }

     */
  }


  Future navigateToWindowSettings(context) async {
    windowSettings win = windowSettings(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowUserProfile(context) async {
    Ref_Window.Ref_Management.Load();

    UserModel user = UserModel(
      uid: Ref_Window.Ref_Management.SETTINGS.Get("WND_USER_PROFILE_UID", "-1"),
      email: Ref_Window.Ref_Management.SETTINGS.Get("WND_DRAWER_EMAIL", ""),
      username: Ref_Window.Ref_Management.SETTINGS
          .Get("WND_USER_PROFILE_USERNAME", ""),
      fullName: Ref_Window.Ref_Management.SETTINGS.Get("WND_DRAWER_NAME", ""),
      registerDate: Ref_Window.Ref_Management.SETTINGS
          .Get("WND_USER_PROFILE_REGDATE", ""),
      lastChangedDate:
          Ref_Window.Ref_Management.SETTINGS.Get("WND_DRAWER_LASTDATE", ""),
      location: Ref_Window.Ref_Management.SETTINGS
          .Get("WND_USER_PROFILE_LOCATION", ""),
      image: Ref_Window.Ref_Management.SETTINGS.Get("WND_DRAWER_IMAGE", ""),
      online: Ref_Window.Ref_Management.SETTINGS.Get("WND_DRAWER_ONLINE", ""),
      lastLogInDate: Ref_Window.Ref_Management.SETTINGS
          .Get("WND_USER_PROFILE_LOGIN_DATE", ""),
      lastSignOutDate: Ref_Window.Ref_Management.SETTINGS
          .Get("WND_USER_PROFILE_SIGNOUT_DATE", ""),
    );

    windowUserProfile win = windowUserProfile(Ref_Window.Ref_Management, user);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowHome(context) async {
    windowHome win = windowHome(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowInitial(context) async {
    MyHomePage win = MyHomePage(Ref_Window.Ref_Management,
        Ref_Window.Ref_Management.GetDefinicao("TITULO_APP", "TITULO_APP ??"));
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowFeedback(context) async {
    windowFeedback win = windowFeedback(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(140),
                  ),
                  child: Expanded(
                    child: _dataLoaded
                        ? (_hasImage
                        ? SizedBox(
                      width: 200,
                      height: 200,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(
                            loadedImages[0]['url']),
                      ),
                    )
                        : const SizedBox(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor:
                        Colors.transparent,
                        backgroundImage: AssetImage(
                            "assets/LOGO.png"),
                      ),
                    ))
                        : Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context)
                            .iconTheme
                            .color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("WND_HOME_DRAWER_SUBTITLE_1", "HOME"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowHome(context)},
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("WND_HOME_DRAWER_SUBTITLE_2", "PROFILE"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowUserProfile(context)},
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("WND_HOME_DRAWER_SUBTITLE_3", "SETTINGS"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowSettings(context)},
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.border_color),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("WND_HOME_DRAWER_SUBTITLE_4", "FEEDBACK"),
            ),
            titleTextStyle: Theme.of(context).textTheme.titleLarge,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: () => {navigateToWindowFeedback(context)},
          ),
          Spacer(),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // Add a bottom margin here
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: ListTile(
                title: Align(
                  child: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("WND_HOME_DRAWER_SUBTITLE_5", "LOGOUT"),
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(),
                  ),
                ),
                onTap: () async {
                  UserModel? userData =
                  await userFirestore.getUserData(
                      FirebaseAuth.instance.currentUser!.uid);
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
                  navigateToWindowInitial(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
