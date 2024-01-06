import 'dart:core';
import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/theme_provider.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../common/widgets/modals/modalPostViewer.dart';
import '../firestore/post_firestore.dart';
import '../firestore/user_firestore.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowSearch extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;

  //--------------
  windowSearch(this.Ref_Management) {
    windowTitle = "Search Window";
    Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    Utils.MSG_Debug(windowTitle + ":Load");
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowSearch(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowSearch extends State<windowSearch> {
  List<Map<String, dynamic>> myData = [];
  final formKey = GlobalKey<FormState>();

  List<PostModel> loadedPosts = [];
  List<PostModel> filteredPosts = [];
  List<int> localLikes = [];
  bool _dataLoaded = false;

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
  final Duration _animationDuration = const Duration(milliseconds: 200);

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
        filteredPosts = loadedPosts;
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

  bool _isLoading = true;

  final windowSearch Ref_Window;
  String className = "";

  //--------------
  State_windowSearch(this.Ref_Window) : super() {
    className = "State_windowSearch";
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
    super.initState();
    myScroll();
  }

  //------ Start of Database
  final TextEditingController _searchController = TextEditingController();

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  List<PostModel> filterList() {
    String search = _searchController.text.toLowerCase();
    if (search.isNotEmpty) {
      return loadedPosts
          .where((element) => element.title.toLowerCase().contains(search))
          .toList();
    } else {
      return loadedPosts;
    }
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    UserFirestore userFirestore = UserFirestore();
    PostFirestore postFirestore = PostFirestore();
    Ref_Window.Ref_Management.Load();

    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        theme: provider.currentTheme,
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back), // Back button icon
              onPressed: () {
                // Define the action when the back button is pressed
                Navigator.of(context).pop(); // Navigator.pop() to go back
              },
            ),
            title: Text(
              Ref_Window.Ref_Management.SETTINGS
                  .Get("WND_SEARCH_TITLE_1", "Search"),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                              "WND_FULL_POST_COMMENT_TEXT_LABEL",
                              "Search something..."),
                          labelStyle: Theme.of(context).textTheme.labelLarge,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: formValidator,
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            filteredPosts = filterList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Builder(builder: (BuildContext context) {
                    return FutureBuilder(
                      future: _dataLoaded ? null : getData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                  : filteredPosts.isEmpty
                                      ? Center(
                                          child: Text(Ref_Window
                                              .Ref_Management.SETTINGS
                                              .Get("JNL_HOME_TITLE_1",
                                                  "No Posts !")))
                                      : ListView.builder(
                                          itemCount: filteredPosts.length,
                                          itemBuilder: (context, index) {
                                            if (localLikes.length <= index) {
                                              localLikes.add(int.parse(
                                                  filteredPosts[index].likes));
                                            }
                                            return GestureDetector(
                                              onTap: () {
                                                /* modalPost.show(
                                                  context, loadedPosts[index], loaded);
                                            },

                                              */
                                                Utils.MSG_Debug("TEST");
                                              },
                                              child: Hero(
                                                tag:
                                                    'postHero${filteredPosts[index].pid}',
                                                child: Card(
                                                  shape:
                                                      const ContinuousRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.zero,
                                                  ),
                                                  elevation: 0,
                                                  // Set elevation to 0 to remove the shadow
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Row(
                                                          children: [
                                                            const CircleAvatar(
                                                              radius: 20,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      'assets/PORSCHE_MAIN_2.jpeg'),
                                                            ),
                                                            const SizedBox(
                                                                width: 10),
                                                            FutureBuilder<
                                                                String>(
                                                              future: userFirestore
                                                                  .getUserAttribute(
                                                                      filteredPosts[
                                                                              index]
                                                                          .uid,
                                                                      'fullName'),
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
                                                                  String
                                                                      fullName =
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
                                                      ListTile(
                                                        title: Text(
                                                          filteredPosts[index]
                                                              .title,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "Date: ${filteredPosts[index].date}"),
                                                            Text(
                                                                "Free Seats: ${filteredPosts[index].freeSeats}/${filteredPosts[index].totalSeats}"),
                                                            Text(
                                                                "Location: ${filteredPosts[index].location}"),
                                                            // Add more attributes as needed
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          if (currentUserUID ==
                                                              filteredPosts[
                                                                      index]
                                                                  .uid) ...[
                                                            IconButton(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onPrimary,
                                                                icon: const Icon(
                                                                    Icons.edit),
                                                                onPressed: () =>
                                                                    {
                                                                      setState(
                                                                          () {})
                                                                    }),
                                                            IconButton(
                                                              color: Colors
                                                                  .red[300],
                                                              icon: const Icon(
                                                                  Icons.delete),
                                                              onPressed: () {
                                                                // Handle delete functionality
                                                              },
                                                            ),
                                                          ] else ...[
                                                            Text(
                                                              localLikes[index]
                                                                  .toString(),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            ),
                                                            IconButton(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                              icon:
                                                                  FutureBuilder<
                                                                      bool>(
                                                                future: postFirestore.getIsLikedStatus(
                                                                    currentUserUID!,
                                                                    filteredPosts[
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
                                                                    return snapshot.data ??
                                                                            false
                                                                        ? Icon(
                                                                            Icons
                                                                                .thumb_up_alt,
                                                                            color: Theme.of(context)
                                                                                .colorScheme
                                                                                .secondaryContainer)
                                                                        : const Icon(
                                                                            Icons.thumb_up_alt_outlined);
                                                                  }
                                                                },
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // Replace with your logic to get the current user's UID
                                                                PostFirestore
                                                                    postManager =
                                                                    PostFirestore();

                                                                int updatedLikes =
                                                                    await postManager.toggleActionPost(
                                                                        currentUserUID!,
                                                                        filteredPosts[
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
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onPrimary,
                                                              icon: const Icon(
                                                                  Icons
                                                                      .message),
                                                              onPressed: () {
                                                                // Handle message functionality
                                                              },
                                                            ),
                                                          ],
                                                          IconButton(
                                                            color: Theme.of(
                                                                    context)
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
                  }),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
//--------------
//--------------
//--------------
}
