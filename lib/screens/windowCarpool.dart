import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ubi/firebase_auth_implementation/models/carpool_model.dart';
import 'package:ubi/firestore/user_firestore.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/theme_provider.dart';
import '../firebase_auth_implementation/models/notification_model.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../firestore/firebase_storage.dart';
import '../firestore/post_firestore.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowCarpool extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();

  //--------------
  windowCarpool(this.Ref_Management) {
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
    return State_windowNotification(this);
  }

//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowNotification extends State<windowCarpool> {
  PostFirestore postFirestore = PostFirestore();
  UserFirestore userFirestore = UserFirestore();

  final formKey = GlobalKey<FormState>();

  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<CarpoolModel> loadedCarpools = [];

  List<CarpoolModel> loadedCarpooling = [];
  List<UserModel> loadedUsersCarpooling = [];
  List<PostModel> loadedPostsCarpooling = [];

  List<UserModel> loadedUsers = [];
  List<PostModel> loadedPosts = [];

  bool _dataLoaded = false;
  bool _isLoading = true;

  Future<void> getData() async {
    try {
      if (!_dataLoaded) {
        Utils.MSG_Debug("Fetching carpools for user $currentUserUID");

        List<CarpoolModel> carpools = await postFirestore.getCarpools(currentUserUID);

        List<UserModel> users = [];
        List<PostModel> posts = [];

        List<CarpoolModel> carpooling = [];
        List<UserModel> usersCarpooling = [];
        List<PostModel> postsCarpooling = [];

        if(carpools.length != 0) {
          for (int i = 0; i < carpools.length; i++) {

            // Assuming you have a method to get user data
            UserModel? user = await userFirestore.getUserData(carpools[i].from_uid);

            if(carpools[i].from_uid != currentUserUID){
              if (user != null) {
                users.add(user);
              } else {
                Utils.MSG_Debug("User data not found for carpool: ${carpools[i]}");
              }
              PostModel? postData = await postFirestore.getPostByPid(
                  carpools[i].from_uid, carpools[i].pid);
              if (postData != null) {
                posts.add(postData);
              } else {
                Utils.MSG_Debug("Post data not found for carpool: ${carpools[i]}");
              }
            }
            else {
              if (user != null) {
                usersCarpooling.add(user);
              } else {
                Utils.MSG_Debug("User data not found for carpool: ${carpools[i]}");
              }
              // Assuming you have a method to get post data
              PostModel? postData = await postFirestore.getPostByPid(carpools[i].req_id, carpools[i].pid);
              carpooling.add(carpools[i]);
              postsCarpooling.add(postData!);
              if (postData != null) {
                posts.add(postData);
              } else {
                Utils.MSG_Debug("Post data not found for carpool: ${carpools[i]}");
              }
            }

          }
        }

        setState(() {
          _dataLoaded = true;
          _isLoading = false;
          loadedCarpools = carpools;
          loadedUsers = users;
          loadedPosts = posts;

          loadedCarpooling = carpooling;
          loadedUsersCarpooling = usersCarpooling;
          loadedPostsCarpooling = postsCarpooling;

        });

        Utils.MSG_Debug("Data loaded successfully");
      } else {
        // Logic to load data from local storage (if needed)
      }
    } catch (e) {
      Utils.MSG_Debug("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


  final windowCarpool Ref_Window;
  String className = "";

  //--------------
  State_windowNotification(this.Ref_Window) : super() {
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
    if (!_dataLoaded) {
      getData();
    }
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();

    return Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: provider.currentTheme,
            home: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", ""),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      setState(() {_dataLoaded = false;});
                      await getData();
                    },
                  ),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _dataLoaded = false;
                  });
                  await getData();
                },
                child: DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize: const Size.fromHeight(kToolbarHeight),
                      child: AppBar(
                        bottom: const TabBar(
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Tab(text: ("Carpooler"),),  /// management
                            Tab(text: ("Carpooling"),),  /// management
                          ],
                        ),
                      ),
                    ),
                    body: TabBarView(
                      children: [
                        // Content for the "All" tab
                        _buildCarpoolerTab(),
                        // Content for the "Requests" tab
                        _buildCarpoolingTab(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );});
  }

  Widget _buildCarpoolerTab() {
    return Builder(builder: (BuildContext context) {
      return FutureBuilder(
        future: _dataLoaded ? null : getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else if (snapshot.hasError) {
            Utils.MSG_Debug("Error: ${snapshot.error}");
            return Center(
              child: Text("Error loading data"),  /// management
            );
          } else {
            return Container(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : loadedCarpooling.isEmpty
                  ? Center(
                child: Text(
                  Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", "0 Notifications!",),),)
                  : ListView.builder(
                itemCount: loadedCarpooling.length,
                itemBuilder: (context, index) {

                  return Hero(
                    tag: 'userHero${loadedCarpooling[index].date}',
                    child: Card(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(loadedUsersCarpooling[index].fullName),
                                const Spacer(),
                                Text(Utils.formatTimeDifference(loadedCarpooling[index].date)),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            title: Text(
                             loadedPostsCarpooling[index].date,
                              style: Theme.of(context).textTheme.titleMedium,),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                buildSubtitle(loadedUsersCarpooling[index].fullName, 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    });
  }

  Widget _buildCarpoolingTab() {
    return Builder(builder: (BuildContext context) {
      return FutureBuilder(
        future: _dataLoaded ? null : getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else if (snapshot.hasError) {
            Utils.MSG_Debug("Error: ${snapshot.error}");
            return Center(
              child: Text("Error loading data"),  /// management
            );
          } else {
            return Container(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : loadedCarpools.isEmpty
                  ? Center(
                child: Text(
                  Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", "0 Notifications!",),),)
                  : ListView.builder(
                itemCount: loadedCarpools.length,
                itemBuilder: (context, index) {

                  return Hero(
                    tag: 'userHero${loadedCarpools[index].date}',
                    child: Card(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Text("from: @${loadedUsers[index].username}", style: Theme.of(context).textTheme.titleMedium,),
                                const Spacer(),
                                Text(Utils.formatTimeDifference(loadedCarpools[index].date)),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            title:
                            buildSubtitle(loadedUsers[index].fullName, 1),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${Ref_Window.Ref_Management.SETTINGS.Get("WND_CARPOOL_TEXT_DATE", "Date: ")}"
                                      "${loadedPosts[index].date}"
                                      "\n${Ref_Window.Ref_Management.SETTINGS.Get("WND_CARPOOL_TEXT_FROM", "From: ")}"
                                      "${loadedPosts[index].startLocation}"
                                      "\n${Ref_Window.Ref_Management.SETTINGS.Get("WND_CARPOOL_TEXT_TO", "To: ")}"
                                      "${loadedPosts[index].endLocation}",
                                  style: Theme.of(context).textTheme.titleSmall,),
                                SizedBox(height: 8),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    });
  }

//--------------
  Widget buildSubtitle(String text, int notificationType) {
    switch (notificationType) {
      case 0:
        return GestureDetector(
          onTap: () {},
          child: Text("$text has requested a carpool!"),  /// management
        );
      case 1:
        return GestureDetector(
          onTap: () {},
          child: Text("$text has accepted the request you sent!"),  /// management
        );
      case 2:
        return GestureDetector(
          onTap: () {},
          child: Text("$text liked your post"),  /// management
        );
      default:
        return Text("Default content");  /// management
    }
  }

//--------------
//--------------
}
