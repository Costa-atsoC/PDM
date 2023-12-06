import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:ubi/screens/windowFeedback.dart';
import 'common/Drawer.dart';
import 'common/widgets/modals/modalNewPost.dart';
import 'common/widgets/modals/modalUpdatePost.dart';

import 'common/Management.dart';
import 'common/Utils.dart';
import 'common/appTheme.dart';
import 'common/widgets/modals/modalPostViewer.dart';
import 'firebase_auth_implementation/models/post_model.dart';
import 'firestore/post_firestore.dart';
import 'screens/windowSearch.dart';
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
  PlatformFile? pickedFile;

  final windowHome Ref_Window;
  String className = "";

  List<PostModel> loadedPosts = [];
  List<int> localLikes = [];
  List<String> loadedUsers = [];
  bool _dataLoaded = false;

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
  }

  //--------------
  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
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
    myScroll();
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          //_show = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          //_show = true;
          showBottomBar();
        }
      }
    });
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  //------ END OF DATABASE

  bool _showAppbar = true; //this is to show app bar
  final ScrollController _scrollBottomBarController =
      ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  final bool _showFab = true;
  bool _show = true;
  double bottomBarHeight = 60; // set bottom bar height
  final Duration _animationDuration = Duration(milliseconds: 200);

  final FloatingActionButtonLocation _fabLocation =
      FloatingActionButtonLocation.endDocked;

  //-------------

  Future navigateToWindowSearch(context) async {
    windowSearch win = windowSearch(Ref_Window.Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    UserFirestore userFirestore = UserFirestore();
    PostFirestore postFirestore = PostFirestore();
    Ref_Window.Ref_Management.Load();

    return MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(
            drawer: CustomDrawer(Ref_Window.Ref_Management),
            appBar: PreferredSize(
              preferredSize:
                  Size.fromHeight(_showAppbar ? kToolbarHeight + 30 : 0.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: _showAppbar ? kToolbarHeight + 30 : 0.0,
                child: AppBar(
                  title: Text(Ref_Window.Ref_Management.SETTINGS
                      .Get("JNL_HOME_TITLE_1", "")),
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
              ),
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
                                    child: Text(Ref_Window
                                        .Ref_Management.SETTINGS
                                        .Get("JNL_HOME_TITLE_1", "No Posts !")))
                                : ListView.builder(
                                    controller: _scrollBottomBarController,
                                    itemCount: loadedPosts.length,
                                    itemBuilder: (context, index) {
                                      if (localLikes.length <= index) {
                                        localLikes.add(int.parse(
                                            loadedPosts[index].likes));
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          modalPost.show(
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
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      //Click to go to that user profile
                                                      GestureDetector(
                                                        onTap: () async {
                                                          UserModel? userData =
                                                              await userFirestore
                                                                  .getUserData(
                                                                      loadedPosts[
                                                                              index]
                                                                          .uid);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  windowUserProfile(
                                                                Ref_Window
                                                                    .Ref_Management,
                                                                userData!,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 20,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/PORSCHE_MAIN_2.jpeg'),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Column(children: [
                                                        Text(loadedPosts[index]
                                                            .userFullName),
                                                        Text(loadedPosts[index]
                                                            .username),
                                                      ]),
                                                      const Spacer(),
                                                      Text(loadedPosts[index]
                                                          .registerDate)
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
                                                        "Date: ${loadedPosts[index].date}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge,
                                                      ),
                                                      Text(
                                                        "From: ${loadedPosts[index].startLocation} \nTo: ${loadedPosts[index].endLocation} ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge,
                                                      ),
                                                      Text(
                                                        "Description: ${loadedPosts[index].description}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge,
                                                      ),
                                                      Text(
                                                        "Free Seats: ${loadedPosts[index].freeSeats}/${loadedPosts[index].totalSeats}",
                                                        style: Theme.of(context).textTheme.labelLarge,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                        onPressed: () async {
                                                          ModalUpdatePost.show(
                                                              context,
                                                              loadedPosts[
                                                                  index]);
                                                          setState(() {});
                                                        },
                                                      ),
                                                      IconButton(
                                                        color: Colors.red[300],
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
                                                                title: const Text(
                                                                    'Confirm Delete'),
                                                                content: const Text(
                                                                    'Are you sure you want to delete this post?'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(); // Close the dialog
                                                                    },
                                                                    child: const Text(
                                                                        'Cancel'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      // Close the dialog and delete the post
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      PostFirestore().deletePost(
                                                                          currentUserUID!,
                                                                          loadedPosts[index]
                                                                              .pid);
                                                                      //MISSING THE REFRESH!!
                                                                    },
                                                                    child: const Text(
                                                                        'Delete'),
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
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium,
                                                      ),
                                                      IconButton(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        icon:
                                                            FutureBuilder<bool>(
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
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondaryContainer)
                                                                  : const Icon(Icons
                                                                      .thumb_up_alt_outlined);
                                                            }
                                                          },
                                                        ),
                                                        onPressed: () async {
                                                          // Replace with your logic to get the current user's UID
                                                          PostFirestore
                                                              postManager =
                                                              PostFirestore();

                                                          int updatedLikes =
                                                              await postManager
                                                                  .toggleLikePost(
                                                                      currentUserUID!,
                                                                      loadedPosts[
                                                                          index]);

                                                          setState(() {
                                                            localLikes[index] =
                                                                updatedLikes;
                                                          });
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
            floatingActionButton: _showFab
                ? Padding(
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
                  )
                : null,
            floatingActionButtonLocation: _fabLocation,
            bottomNavigationBar: AnimatedContainer(
              duration: _animationDuration,
              height: _show ? bottomBarHeight : 0,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0, // Adjust the margin value as needed
                  ),
                  IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      navigateToWindowSearch(context);
                    },
                  ),
                  IconButton(
                    tooltip: 'Notifications',
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  ),
                ],
              ),
            )));
  }
}
