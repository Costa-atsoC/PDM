import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowPostForm.dart';

import 'package:ubi/windowSettings.dart';
import 'common/Management.dart';
import 'common/Utils.dart';
import 'common/appTheme.dart';
import 'common/widgets/DetailScreen.dart';
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
    Ref_Management.Load();
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

  // PARA FOTOS, IMPLEMENTAR NO PERFIL!
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
    try {
      List<PostModel> newPosts = await PostFirestore().getAllPosts();
      setState(() {
        loadedPosts.clear(); // Clear the list before adding new data
        loadedPosts.addAll(newPosts);
        _isLoading = false; // Data has been loaded
        _dataLoaded = true; // Set the flag to true after loading data
      });
    } catch (e) {
      Utils.MSG_Debug("Error fetching data: $e");
      setState(() {
        _isLoading = false; // Set isLoading to false even in case of an error
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;

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

  final bool _showFab = true;
  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  Future navigateToWindowHome(context) async {
    windowHome win = windowHome(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowUserProfile(context) async {
    windowUserProfile win = windowUserProfile(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowSearch(context) async {
    windowSearch win = windowSearch(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowSettings(context) async {
    windowSettings win = windowSettings(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //-------------
/*
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

 */

  //--------------
  @override
  Widget build(BuildContext context) {
    UserFirestore userFirestore = UserFirestore();
    Ref_Window.Ref_Management.Load();

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
          drawer: Drawer(
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
                      const SizedBox(height: 10), // Espaço entre a foto e o texto
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
                  onTap: () => {},
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
                                        .primaryContainer,
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
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          appBar: AppBar(
            title: Text(
                Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", "")),
          ),
          body: RefreshIndicator(onRefresh: () async {
            await getData();
            setState(() {

            });
          }, child: Builder(builder: (BuildContext context) {
            return FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 19, 40, 61),
                    ),
                  );
                } else if (snapshot.hasError) {
                  Utils.MSG_Debug("Error: ${snapshot.error}");
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
                              ? Center(
                                  child: Text(Ref_Window.Ref_Management.SETTINGS
                                      .Get("JNL_HOME_TITLE_1", "No Posts !")))
                              : ListView.builder(
                                  itemCount: loadedPosts.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        DetailScreen.show(
                                            context, loadedPosts[index]);
                                      },
                                      child: Hero(
                                        tag:
                                            'postHero${loadedPosts[index].pid}',
                                        child: Card(
                                          //margin: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: Theme.of(context)
                                                    .colorScheme.onSecondary
                                                    .withOpacity(0.5),
                                                // Set your desired color
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      const CircleAvatar(
                                                        radius: 20,
                                                        backgroundImage: AssetImage(
                                                            'assets/PORSCHE_MAIN_2.jpeg'),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      FutureBuilder<String>(
                                                        future: userFirestore
                                                            .getUserAttribute(
                                                          loadedPosts[index]
                                                              .uid,
                                                          'fullName',
                                                        ),
                                                        builder: (context,
                                                            userSnapshot) {
                                                          if (userSnapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Text(
                                                                "User: Loading...");
                                                          } else if (userSnapshot
                                                              .hasError) {
                                                            return const Text(
                                                                "User: Error loading user data");
                                                          } else {
                                                            String fullName =
                                                                userSnapshot
                                                                        .data ??
                                                                    "Unknown";
                                                            return Text(
                                                                "User: $fullName");
                                                          }
                                                        },
                                                      ),
                                                    ],
                                               
                                                ),
                                              ),
                                              Container(
                                                color: Theme.of(context).scaffoldBackgroundColor,
                                                // Set your desired color
                                                child: ListTile(
                                                  title: Text(
                                                    loadedPosts[index].title,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium,
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "Date: ${loadedPosts[index].date}"),
                                                      Text(
                                                          "Free Seats: ${loadedPosts[index].freeSeats}/${loadedPosts[index].totalSeats}"),
                                                      Text(
                                                          "Location: ${loadedPosts[index].location}"),
                                                      // Add more attributes as needed
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: Theme.of(context)
                                                    .colorScheme.onSecondary
                                                    .withOpacity(0.5),
                                                // Set your desired color
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    if (currentUserUID ==
                                                        loadedPosts[index]
                                                            .uid) ...[
                                                      IconButton(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        icon: const Icon(
                                                            Icons.edit),
                                                        onPressed: () =>
                                                            showMyForm(
                                                                loadedPosts[index]
                                                                        .pid
                                                                    as int?),
                                                      ),
                                                      IconButton(
                                                        color: Colors.red[300],
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        onPressed: () {
                                                          // Handle delete functionality
                                                        },
                                                      ),
                                                    ] else ...[
                                                      Text(loadedPosts[index].likes, style: Theme.of(context).textTheme.titleMedium,),
                                                      IconButton(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        icon: const Icon(
                                                            Icons.thumb_up),
                                                        onPressed: () async {
                                                          // Replace with your logic to get the current user's UID
                                                          PostFirestore postManager = PostFirestore();

                                                          await postManager.toggleLikePost(currentUserUID!, loadedPosts[index]);
                                                        },
                                                      ),
                                                      IconButton(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        icon: const Icon(
                                                            Icons.message),
                                                        onPressed: () {
                                                          // Handle message functionality
                                                        },
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ));
                }
              },
            );
          })),
          floatingActionButton: _showFab
              ? Container(
                  width: 70.0, // Set the width
                  height: 70.0, // Set the height
                  child: FloatingActionButton(
                    onPressed: () => showMyForm(null),
                    backgroundColor: const Color.fromARGB(230, 44, 71, 131),
                    splashColor: Colors.white,
                    tooltip: 'Create',
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      size: 33.0, // Adjust the size to increase the icon size
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
          floatingActionButtonLocation: _fabLocation,
          bottomNavigationBar: BottomAppBar(
            height: 60,
            shape: const CircularNotchedRectangle(),
            color: Theme.of(context)
                .appBarTheme
                .backgroundColor, // mudar para Theme
            child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.secondary),
              child: Row(
                children: <Widget>[
                  IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      navigateToWindowSearch(context);
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
