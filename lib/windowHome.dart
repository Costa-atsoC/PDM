import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowInitial.dart';
import 'package:ubi/screens/windowPostForm.dart';

import 'package:ubi/windowSettings.dart';
import 'package:uuid/uuid.dart';
import 'common/Management.dart';
import 'common/Utils.dart';
import 'firebase_auth_implementation/models/post_model.dart';
import 'firestore/post_firestore.dart';
import 'windowSearch.dart';
import 'screens/windowUserProfile.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowHome extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final storage = FirebaseStorage.instance; // firestore
  int? ACCESS_WINDOW_HOME;

  //--------------
  windowHome(this.Ref_Management) {
    windowTitle = "Home";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
    ACCESS_WINDOW_HOME = await Ref_Management.Get_SharedPreferences_INT(
        "JANELA_HOME_NUMERO_ACESSOS");
    Ref_Management.Save_Shared_Preferences_INT(
        "JANELA_HOME_NUMERO_ACESSOS", ACCESS_WINDOW_HOME! + 1);
  }

  int? Get_ACESSO_JANELA_HOME() {
    return ACCESS_WINDOW_HOME;
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowHome(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowHome extends State<windowHome> {
  PlatformFile? pickedFile;

  final windowHome Ref_Window;
  String className = "";

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  List<PostModel> loadedPosts = [];
  bool _dataLoaded = false;

  // Updated getData method
  Future getData() async {
    if (_dataLoaded) {
      return; // Skip fetching data if it's already loaded
    }

    String? uid =
        await Ref_Window.Ref_Management.Get_SharedPreferences_STRING("UID");
    try {
      List<PostModel> newPosts = await PostFirestore().getAllPosts();
      setState(() {
        loadedPosts.clear(); // Clear the list before adding new data
        loadedPosts.addAll(newPosts);
        _isLoading = false; // Data has been loaded
        _dataLoaded = true; // Set the flag to true after loading data
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false; // Set isLoading to false even in case of an error
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;

  //------ end of database constants

  //--------------
  State_windowHome(this.Ref_Window) : super() {
    className = "State_windowHome";
    Utils.MSG_Debug("$className: createState");
  }

  //--------------
  @override
  void dispose() {
    Utils.MSG_Debug("createState");
    super.dispose();
    Utils.MSG_Debug("$className:dispose");
  }

  //--------------
  @override
  void deactivate() {
    Utils.MSG_Debug("$className:deactivate");
    super.deactivate();
  }

  //--------------
  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("$className: didChangeDependencies");
    super.didChangeDependencies();
  }

  //--------------
  @override
  void initState() {
    Utils.MSG_Debug("$className: initState");
    getData();
    super.initState();
  }

  void showMyForm(int? id) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostForm(Ref_Window.Ref_Management)),
    );
  }

  //------ END OF DATABASE

  bool _showFab = true;
  FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  Future NavigateTo_Window_Home(context) async {
    windowHome win = new windowHome(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future NavigateTo_Window_User_Profile(context) async {
    windowUserProfile win = new windowUserProfile(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future NavigateTo_Window_Search(context) async {
    windowSearch win = new windowSearch(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future NavigateTo_Window_Settings(context) async {
    windowSettings win = new windowSettings(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------------
  GetID() async {
    final String userID;
    userID = (await Ref_Window.Ref_Management.ACCESS_NUMBER) as String;
    return userID;
  }

  //-------------

  Widget CriarButton_Shared_Preferences() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
      ),
      child: Text(
        Ref_Window.Ref_Management.GetDefinicao(
            "TITULO_BTN_SHARED_PREFERENCE", "SHARED_PREFERENCE ??"),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () async {
        UtilsFlutter.MSG(Ref_Window.Ref_Management.GetDefinicao(
            "TITULO_BTN_SHARED_PREFERENCE", "Accao-BTN_SHARED_PREFERENCE ??"));

        int CLICKS_SP =
            await Ref_Window.Ref_Management.Get_SharedPreferences_INT(
                "CLICKS_SP") as int;
        UtilsFlutter.MSG("CLICKS_SP = $CLICKS_SP");
        Ref_Window.Ref_Management.Save_Shared_Preferences_INT(
            "CLICKS_SP", CLICKS_SP + 1);
      },
    );
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Utils.MSG_Debug("$className: build");
    UserFirestore userFirestore = UserFirestore();

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: Drawer(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/cover.jpg'),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30, // Tamanho do círculo
                        backgroundImage:
                            AssetImage('caminho/para/foto_de_perfil.jpg'),
                      ),
                      SizedBox(height: 10), // Espaço entre a foto e o texto
                      Text(
                        Ref_Window.Ref_Management.SETTINGS
                            .Get("WND_HOME_DRAWER_TITLE_1", "NAME"),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.input),
                  // meter o logo da app
                  iconColor: Theme.of(context).iconTheme.color,
                  title: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_HOME_DRAWER_SUBTITLE_1", "WELCOME"),
                  ),
                  // adicionar ao management
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  iconColor: Theme.of(context).iconTheme.color,
                  title: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_HOME_DRAWER_SUBTITLE_2", "PROFILE"),
                  ),
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: () => {NavigateTo_Window_User_Profile(context)},
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  iconColor: Theme.of(context).iconTheme.color,
                  title: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_HOME_DRAWER_SUBTITLE_3", "SETTINGS"),
                  ),
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: () => {NavigateTo_Window_Settings(context)},
                ),
                ListTile(
                  leading: Icon(Icons.border_color),
                  iconColor: Theme.of(context).iconTheme.color,
                  title: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_HOME_DRAWER_SUBTITLE_4", "FEEDBACK"),
                  ),
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  iconColor: Theme.of(context).iconTheme.color,
                  title: Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("JNL_HOME_DRAWER_SUBTITLE_5", "LOGOUT"),
                  ),
                  titleTextStyle: Theme.of(context).textTheme.titleMedium,
                  onTap: () => {
                    Ref_Window.Ref_Management.Delete_Shared_Preferences(
                        "EMAIL"),
                    Ref_Window.Ref_Management.Delete_Shared_Preferences("NAME"),
                    FirebaseAuth.instance.signOut(),
                    Navigator.of(context).pop(),
                  },
                ),
              ],
            ),
          ),
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(Ref_Window.Ref_Management.SETTINGS
                .Get("JNL_HOME_TITLE_1", "Home Page 1")),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await getData();
              setState(() {});
            },
            child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print("Error: ${snapshot.error}");
                  return const Center(
                    child: Text("Error loading data"),
                  );
                } else {
                  String? currentUserUID =
                      FirebaseAuth.instance.currentUser?.uid;

                  return Container(
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : loadedPosts.isEmpty
                              ? const Center(
                                  child: Text("No Data Available!!!"))
                              : ListView.builder(
                                  itemCount: loadedPosts.length,
                                  itemBuilder: (context, index) => Card(
                                    color: index % 2 == 0
                                        ? const Color.fromARGB(
                                            255, 201, 128, 94)
                                        : Color.fromARGB(255, 201, 108, 94),
                                    margin: const EdgeInsets.all(15),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            radius: 20, // Adjust the radius as needed
                                            backgroundImage: NetworkImage('https://example.com/user_profile_image.jpg'), // Add the user's profile image URL
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                loadedPosts[index].title,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "Date: ${loadedPosts[index].date}"),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FutureBuilder<String>(
                                                future: userFirestore.getUserAttribute(
                                                    loadedPosts[index].uid, 'fullName'),
                                                builder: (context, userSnapshot) {
                                                  if (userSnapshot.connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Text("User: Loading...");
                                                  } else if (userSnapshot.hasError) {
                                                    return Text("User: Error loading user data");
                                                  } else {
                                                    String fullName =
                                                        userSnapshot.data ?? "Unknown";
                                                    return Text("User: $fullName");
                                                  }
                                                },
                                              ),
                                              Text(
                                                  "Description: ${loadedPosts[index].description}"),
                                              Text(
                                                  "Total Seats: ${loadedPosts[index].totalSeats}"),
                                              Text(
                                                  "Free Seats: ${loadedPosts[index].freeSeats}"),
                                              Text(
                                                  "UID: ${loadedPosts[index].uid}"),
                                              Text(
                                                  "Location: ${loadedPosts[index].location}"),
                                              // Add more attributes as needed
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              if (currentUserUID ==
                                                  loadedPosts[index].uid) ...[
                                                IconButton(
                                                  color: Colors.white,
                                                  icon: const Icon(Icons.edit),
                                                  onPressed: () => showMyForm(
                                                    loadedPosts[index].pid
                                                        as int?,
                                                  ),
                                                ),
                                                IconButton(
                                                  color: Colors.white,
                                                  icon:
                                                      const Icon(Icons.delete),
                                                  onPressed: () {
                                                    // Handle delete functionality
                                                  },
                                                ),
                                              ] else ...[
                                                IconButton(
                                                  color: Colors.white,
                                                  icon: const Icon(
                                                      Icons.thumb_up),
                                                  onPressed: () {
                                                    // Handle like functionality
                                                  },
                                                ),
                                                IconButton(
                                                  color: Colors.white,
                                                  icon:
                                                      const Icon(Icons.message),
                                                  onPressed: () {
                                                    // Handle send message functionality
                                                  },
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                }
              },
            ),
          ),
          floatingActionButton: _showFab
              ? Container(
                  width: 70.0, // Set the width
                  height: 70.0, // Set the height
                  child: FloatingActionButton(
                    onPressed: () => showMyForm(null),
                    backgroundColor: const Color.fromARGB(230, 44, 71, 131),
                    splashColor: Colors.white,
                    tooltip: 'Create',
                    child: Icon(
                      Icons.add,
                      size: 33.0, // Adjust the size to increase the icon size
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation: _fabLocation,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Theme.of(context).primaryColor, // mudar para Theme
            child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      NavigateTo_Window_Search(context);
                    },
                  ),
                  IconButton(
                    tooltip: 'Favorite',
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
