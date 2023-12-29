import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowFeedback.dart';
import 'package:ubi/screens/windowFullPost.dart';
import 'package:ubi/screens/windowNotifications.dart';
import 'common/Drawer.dart';
import 'common/widgets/modals/modalNewPost.dart';
import 'common/widgets/modals/modalUpdatePost.dart';

import 'common/Management.dart';
import 'common/Utils.dart';
import 'common/appTheme.dart';
import 'common/widgets/modals/modalPostViewer.dart';
import 'firebase_auth_implementation/models/post_model.dart';
import 'firestore/firebase_storage.dart';
import 'firestore/post_firestore.dart';
import 'screens/windowSearch.dart';
import 'screens/windowUserProfile.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowHome extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final storage = FirebaseStorage.instance; // firestore
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();
  int? ACCESS_WINDOW_HOME;

  //--------------
  windowHome(this.Ref_Management) {
    windowTitle = "Home";
    //Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
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
    return State_windowHome(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowHome extends State<windowHome> {
  late windowNotifications _windowNotifications;
  late windowSearch _windowSearch;

  PlatformFile? pickedFile;
  UserFirestore userFirestore = UserFirestore();
  PostFirestore postFirestore = PostFirestore();
  final formKey = GlobalKey<FormState>();

  final windowHome Ref_Window;
  String className = "";

  // for the bottomNavigationBar
  int _currentIndex = 1;

  // ALL THESE METHODS ARE REFRESHED WHEN REFRESH METHODS ARE APPLIED
  // STORES THE POSTS
  List<PostModel> loadedPosts = [];

  // STORES THE LIKES IN THE MOMENT THE POSTS ARE LOADED
  List<int> localLikes = [];

  // STORING THE USER DATA
  List<UserModel> loadedUserProfiles = [];

  // STORING THE PROFILE IMAGES
  List<Map<String, dynamic>> loadedImages = [];

  bool _dataLoaded = false;
  bool _isLoading = true;

  // FUNCTION TO REFRESH THE DATA / GET THE DATA IF IT'S THE FIRST INITIALIZATION
  Future<void> getData() async {
    if (_dataLoaded) {
      return; // Skip fetching data if it's already loaded
    }

    try {
      List<PostModel> newPosts = await PostFirestore().getAllPosts();
      List<UserModel> newUsers = [];
      Map<int, List<Map<String, dynamic>>> postImagesMap =
          {}; // Map to store images by post index

      for (int i = 0; i < newPosts.length; i++) {
        PostModel post = newPosts[i];
        UserModel? userProfile = await userFirestore.getUserData(post.uid);
        Utils.MSG_Debug(userProfile!.fullName);
        newUsers.add(userProfile!);

        List<Map<String, dynamic>> images =
            await Ref_Window.Ref_FirebaseStorage.loadImages(userProfile.uid);
        postImagesMap[i] = images;

        if (images.isNotEmpty) {
          Map<String, dynamic> firstImage = images.first;
          loadedImages.add(firstImage);
        }
      }

      setState(() {
        loadedPosts.clear(); // Clear the list before adding new data
        loadedPosts.addAll(newPosts);

        loadedUserProfiles.clear();
        loadedUserProfiles.addAll(newUsers);

        // Store images by post index
        loadedImages.clear();
        for (int i = 0; i < newPosts.length; i++) {
          List<Map<String, dynamic>> images = postImagesMap[i] ?? [];
          loadedImages.addAll(images);
        }

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

  //--------------
  State_windowHome(this.Ref_Window) : super() {
    className = "State_windowHome";
  }

  //--------------
  @override
  void dispose() {
    super.dispose();
  }

  //--------------
  @override
  void deactivate() {
    //Utils.MSG_Debug("$className:deactivate");
    super.deactivate();
  }

  //--------------
  @override
  void didChangeDependencies() {
    //Utils.MSG_Debug("$className: didChangeDependencies");
    super.didChangeDependencies();
  }

  //--------------
  @override
  void initState() {
    Utils.MSG_Debug("$className: initState");
    super.initState();
    getData();
  }

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.miniEndFloat;

  //-------------

  Future navigateToWindowSearch(context) async {
    windowSearch win = windowSearch(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  } //-------------

  Future navigateToWindowNotifications(context) async {
    windowNotifications win = windowNotifications(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  Future navigateToWindowFulPost(context, post) async {
    windowFullPost win = windowFullPost(Ref_Window.Ref_Management, post);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();
    PostFirestore postManager = PostFirestore();
    return PopScope(
        canPop: false,
        child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: Scaffold(
              drawer: CustomDrawer(Ref_Window.Ref_Management),
              appBar: AppBar(
                title: Text(Ref_Window.Ref_Management.SETTINGS
                    .Get("WND_HOME_TITLE_1", "")),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      setState(() {
                        _dataLoaded = false;
                      });
                      await getData();
                    },
                  ),
                ],
              ),
              body: RefreshIndicator(onRefresh: () async {
                setState(() {
                  _dataLoaded = false;
                });
                await getData();
              }, child: Builder(builder: (BuildContext context) {
                return FutureBuilder(
                  future: _dataLoaded ? null : getData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      Utils.MSG_Debug("Error: ${snapshot.error}");
                      return Center(
                        child: Text(Ref_Window.Ref_Management.SETTINGS.Get(
                            "WND_HOME_ERROR_DATA_TEXT",
                            "WND_HOME_ERROR_DATA_TEXT ??")),
                      );
                    } else {
                      String? currentUserUID =
                          FirebaseAuth.instance.currentUser?.uid;

                      return Container(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : loadedPosts.isEmpty
                                  ? Center(
                                      child: Text(Ref_Window
                                          .Ref_Management.SETTINGS
                                          .Get("JNL_HOME_NO_POSTS_TEXT",
                                              "JNL_HOME_NO_POSTS_TEXT ??")))
                                  : ListView.builder(
                                      itemCount: loadedPosts.length,
                                      itemBuilder: (context, index) {
                                        if (localLikes.length <= index) {
                                          localLikes.add(int.parse(
                                              loadedPosts[index].likes));
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            navigateToWindowFulPost(
                                                context, loadedPosts[index]);
                                          },
                                          child: Hero(
                                            tag:
                                                'postHero${loadedPosts[index].pid}',
                                            child: Card(
                                              shape:
                                                  const ContinuousRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                              ),
                                              elevation: 0,
                                              // Set elevation to 0 to remove the shadow
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        // click to go to that user profile
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => windowUserProfile(
                                                                    Ref_Window
                                                                        .Ref_Management,
                                                                    loadedUserProfiles[
                                                                        index]),
                                                              ),
                                                            );
                                                          },
                                                          child: Expanded(
                                                            child: CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      loadedImages[
                                                                              index]
                                                                          [
                                                                          'url']),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Column(children: [
                                                          Text(
                                                            loadedPosts[index]
                                                                .userFullName,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleSmall,
                                                          ),
                                                          Text(
                                                              "@${loadedPosts[index].username}",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge),
                                                        ]),
                                                        const Spacer(),
                                                        Text(Utils
                                                            .formatTimeDifference(
                                                                loadedPosts[
                                                                        index]
                                                                    .registerDate))
                                                      ],
                                                    ),
                                                  ),
                                                  ListTile(
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
                                                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_DATE_TEXT_LABEL", "Date: ")}${loadedPosts[index].date}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        Text(
                                                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_FROM_TEXT_LABEL", "From: ")}${loadedPosts[index].startLocation} \n${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_TO_TEXT_LABEL", "To ")}${loadedPosts[index].endLocation} ",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                        Text(
                                                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_FREE_SEATS_TEXT_LABEL", "Free Seats: ")}${loadedPosts[index].freeSeats}/${loadedPosts[index].totalSeats}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (currentUserUID ==
                                                          loadedPosts[index]
                                                              .uid) ...[
                                                        IconButton(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          icon: const Icon(
                                                              Icons.edit),
                                                          onPressed: () async {
                                                            ModalUpdatePost
                                                                .show(
                                                                    context,
                                                                    loadedPosts[
                                                                        index]);
                                                            setState(() {});
                                                          },
                                                        ),
                                                        IconButton(
                                                          color:
                                                              Colors.red[300],
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            // Show a confirmation dialog
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(Ref_Window
                                                                      .Ref_Management
                                                                      .SETTINGS
                                                                      .Get(
                                                                          "WND_HOME_POST_DELETE_TEXT_LABEL_1",
                                                                          "Confirm delete")),
                                                                  content: Text(Ref_Window
                                                                      .Ref_Management
                                                                      .SETTINGS
                                                                      .Get(
                                                                          "WND_HOME_POST_DELETE_TEXT_LABEL_2",
                                                                          "Are you sure you want to delete this post?")),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(Ref_Window
                                                                          .Ref_Management
                                                                          .SETTINGS
                                                                          .Get(
                                                                              "WND_HOME_POST_DELETE_TEXT_LABEL_3",
                                                                              "Cancel")),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        // Close the dialog and delete the post
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        PostFirestore().deletePost(
                                                                            currentUserUID!,
                                                                            loadedPosts[index].pid);
                                                                        setState(
                                                                            () {});
                                                                        //MISSING THE REFRESH!!
                                                                      },
                                                                      child: Text(Ref_Window
                                                                          .Ref_Management
                                                                          .SETTINGS
                                                                          .Get(
                                                                              "WND_HOME_POST_DELETE_TEXT_LABEL_4",
                                                                              "Delete")),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ] else ...[
                                                        Text(
                                                          localLikes[index]
                                                              .toString(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        ),
                                                        IconButton(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          icon: FutureBuilder<
                                                              bool>(
                                                            future: postFirestore
                                                                .getIsLikedStatus(
                                                                    currentUserUID!,
                                                                    loadedPosts[
                                                                        index]),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                // If still loading, you can show a loading indicator or default icon
                                                                return const Icon(
                                                                    Icons
                                                                        .thumb_up_alt_outlined);
                                                              } else if (snapshot
                                                                  .hasError) {
                                                                // Handle error
                                                                Utils.MSG_Debug(
                                                                    'Error checking like status: ${snapshot.error}');

                                                                return const Icon(
                                                                    Icons
                                                                        .thumb_up_alt_outlined);
                                                              } else {
                                                                // Determine the appropriate icon based on the like status
                                                                return snapshot
                                                                            .data ??
                                                                        false
                                                                    ? Icon(
                                                                        Icons
                                                                            .thumb_up_alt,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .secondaryContainer)
                                                                    : const Icon(
                                                                        Icons
                                                                            .thumb_up_alt_outlined);
                                                              }
                                                            },
                                                          ),
                                                          onPressed: () async {
                                                            int updatedLikes = await postManager
                                                                .toggleActionPost(
                                                                    currentUserUID!,
                                                                    loadedPosts[
                                                                        index],
                                                                    2);
                                                            setState(() {
                                                              localLikes[
                                                                      index] =
                                                                  updatedLikes;
                                                            });
                                                          },
                                                        ),
                                                        IconButton(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          icon: const Icon(
                                                              Icons.message),
                                                          onPressed: () {
                                                            // Handle message functionality
                                                          },
                                                        ),
                                                        IconButton(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                          icon: const Icon(Icons
                                                              .waving_hand),
                                                          onPressed: () async {
                                                            await postManager
                                                                .toggleActionPost(
                                                                    currentUserUID!,
                                                                    loadedPosts[
                                                                        index],
                                                                    0);
                                                            Utils.MSG_Debug(
                                                                "CARPOOL REQUESTED");
                                                          },
                                                        ),
                                                      ],
                                                      IconButton(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        icon: const Icon(
                                                            Icons.share),
                                                        onPressed: () {
                                                          // Handle message functionality
                                                        },
                                                      ),
                                                    ],
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
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                // Add your desired margin
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  child: FloatingActionButton(
                    onPressed: () => ModalNewPost.show(context),
                    splashColor: Colors.white,
                    tooltip: 'Create',
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      size: 33.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              floatingActionButtonLocation: _fabLocation,
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Adjust the spacing as needed
                children: <Widget>[
                  IconButton(
                    tooltip: 'Search',
                    icon: Icon(
                      Icons.search_rounded,
                      size: double.parse(Ref_Window.Ref_Management.SETTINGS.Get("BOTTOM_NAV_BAR_ICON_SIZE_1", "30")),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      navigateToWindowSearch(context);
                    },
                  ),
                  IconButton(
                    tooltip: 'Home',
                    icon: Icon(
                      Icons.home,
                      size: double.parse(Ref_Window.Ref_Management.SETTINGS.Get("BOTTOM_NAV_BAR_ICON_SIZE_2", "40")),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    tooltip: 'Notifications',
                    icon: Icon(
                      Icons.notifications,
                      size: double.parse(Ref_Window.Ref_Management.SETTINGS.Get("BOTTOM_NAV_BAR_ICON_SIZE_3", "30")),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () {
                      navigateToWindowNotifications(context);
                    },
                  ),
                ],
              ),
            )));
  }
}
