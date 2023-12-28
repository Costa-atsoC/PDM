import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ubi/main.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../firebase_auth_implementation/models/notification_model.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../common/widgets/modals/modalPostViewer.dart';
import '../common/widgets/modals/profileModal/modalProfileViewer.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../firestore/firebase_storage.dart';
import '../firestore/post_firestore.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowNotifications extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();

  //--------------
  windowNotifications(this.Ref_Management) {
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
class State_windowNotification extends State<windowNotifications> {
  PostFirestore postFirestore = PostFirestore();

  final formKey = GlobalKey<FormState>();

  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<NotificationModel> loadedNotifications = [];
  bool _dataLoaded = false;
  bool _isLoading = true;

  Future<void> getData() async {
    try {
      String? notifsJson = await Ref_Window.Ref_Management.Get_SharedPreferences_STRING("USER_NOTIFICATIONS_JSON");

      if (!_dataLoaded || notifsJson == "??") {
        String newNotifications = await postFirestore.getUserNotificationsJson(currentUserUID);
        Ref_Window.Ref_Management.Save_Shared_Preferences_STRING("USER_NOTIFICATIONS_JSON", newNotifications);

        List<NotificationModel> notifications = (jsonDecode(newNotifications) as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        setState(() {
          _dataLoaded = true;
          _isLoading = false;
          loadedNotifications = notifications;
        });
      } else {
        List<NotificationModel> notifications = (jsonDecode(notifsJson!) as List)
            .map((json) => NotificationModel.fromJson(json))
            .toList();

        setState(() {
          _dataLoaded = true;
          _isLoading = false;
          loadedNotifications = notifications;
        });
      }
    } catch (e) {
      Utils.MSG_Debug("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }


  final windowNotifications Ref_Window;
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
    if (_dataLoaded == false) {
      getData();
    }
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  final FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation
      .endDocked; //FloatingActionButtonLocation.endDocked;
  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();

    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", ""),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                setState(() {
                  _dataLoaded = false;
                });
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
            length: 3,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  bottom: const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        text: ("All"),
                      ),
                      Tab(
                        text: ("Requests"),
                      ),
                      Tab(
                        text: ("Likes"),
                      )
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  // Content for the "All" tab
                  _buildAllNotificationsTab(),
                  // Content for the "Requests" tab
                  _buildRequestsTab(),
                  // Content for the "Likes" tab
                  _buildLikesTab(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllNotificationsTab() {
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
              child: Text("Error loading data"),
            );
          } else {
            return Container(
              child: _isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : loadedNotifications.isEmpty
                  ? Center(
                child: Text(
                  Ref_Window.Ref_Management.SETTINGS.Get(
                    "JNL_HOME_TITLE_1",
                    "No Users!",
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: loadedNotifications.length,
                itemBuilder: (context, index) {
                  String notificationText;

                  // Determine the text based on the type
                  if (loadedNotifications[index].type == 0) {
                    notificationText =
                    "@${loadedNotifications[index].fromUid} sent you a carpool request!";
                  } else if (loadedNotifications[index].type == 1) {
                    notificationText =
                    "@${loadedNotifications[index].fromUid} accepted your request!";
                  } else if (loadedNotifications[index].type == 2) {
                    notificationText =
                    "@${loadedNotifications[index].fromUid} liked your post!";
                  } else {
                    // Handle other types or provide a default text
                    notificationText = "New notification!";
                  }

                  return Hero(
                    tag:
                    'userHero${loadedNotifications[index].fromUid}',
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
                                Text(notificationText),
                                const Spacer(),
                                Text(Utils.formatTimeDifference(
                                    loadedNotifications[index].date)),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {},
                            title: Text(
                              notificationText,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                buildSubtitle(
                                    loadedNotifications[index].seen),
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

  Widget _buildRequestsTab() {
    // Implement the UI for the "Reviews" tab
    return Container(
      // Your "Reviews" tab content goes here
      child: Text("Reviews Tab Content"),
    );
  }

  Widget _buildLikesTab() {
    // Implement the UI for the "Reviews" tab
    return Container(
      // Your "Reviews" tab content goes here
      child: Text("Reviews Tab Content"),
    );
  }

//--------------
  Widget buildSubtitle(int notificationType) {
    switch (notificationType) {
      case 0:
        return GestureDetector(
          onTap: () {

          },
          child: Text(
              "Trip"),
        );
      case 1:
        return GestureDetector(
          onTap: () {

          },
          child: Text(
              "Trip:"),
        );
      case 2:
        return GestureDetector(
          onTap: () {

          },
          child: Text(
              "Trip"),
        );
      // Add more cases as needed
      default:
        return Text("Default content");
    }
  }

//--------------
//--------------
}
