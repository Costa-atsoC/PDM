import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ubi/firestore/user_firestore.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/theme_provider.dart';
import '../firebase_auth_implementation/models/notification_model.dart';
import '../firebase_auth_implementation/models/post_model.dart';
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
  UserFirestore userFirestore = UserFirestore();

  final formKey = GlobalKey<FormState>();

  String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<NotificationModel> loadedNotificationsAll = [];
  List<NotificationModel> loadedNotificationsType0 = [];
  List<NotificationModel> loadedNotificationsType1 = [];
  List<NotificationModel> loadedNotificationsType2 = [];

  List<PostModel> loadedPostsType0 = [];
  List<PostModel> loadedPostsType1 = [];
  List<PostModel> loadedPostsType2 = [];

  List<UserModel> loadedUserDataType0 = [];
  List<UserModel> loadedUserDataType1 = [];
  List<UserModel> loadedUserDataType2 = [];

  bool _dataLoaded = false;
  bool _isLoading = true;

  Future<void> getData() async {
    try {
      String? notifsJson =
      await Ref_Window.Ref_Management.Get_SharedPreferences_STRING(
          "USER_NOTIFICATIONS_JSON");

      if (!_dataLoaded || notifsJson == "??") {
        Utils.MSG_Debug("Fetching notifications for user $currentUserUID");
        List<NotificationModel> notifications =
        await postFirestore.getUserNotifications(currentUserUID);

        // Update the SharedPreferences directly with the list of NotificationModel
        Ref_Window.Ref_Management.Save_Shared_Preferences_STRING(
            "USER_NOTIFICATIONS_JSON", jsonEncode(notifications));

        // Separate notifications based on type
        List<NotificationModel> type0Notifications =
        notifications.where((notif) => notif.type == 0).toList();
        List<NotificationModel> type1Notifications =
        notifications.where((notif) => notif.type == 1).toList();
        List<NotificationModel> type2Notifications =
        notifications.where((notif) => notif.type == 2).toList();

        List<PostModel> postsDataType0 = [];
        List<PostModel> postsDataType1 = [];
        List<PostModel> postsDataType2 = [];

        List<UserModel> userDataType0 = [];
        List<UserModel> userDataType1 = [];
        List<UserModel> userDataType2 = [];

        for (int i = 0; i < type0Notifications.length; i++) {
          try {
            PostModel? postData = await postFirestore.getPostByPid(
                type0Notifications[i].toUid, type0Notifications[i].pid);
            postsDataType0.add(postData!);

            String? userDataJson =
            await userFirestore.getUserDataJson(type0Notifications[i].fromUid);
            UserModel? userData =
            UserModel.fromJson(jsonDecode(userDataJson!));
            userDataType0.add(userData);
          } catch (e) {
            // Handle error when getting post data
            Utils.MSG_Debug("Error getting post data: $e");
            // Add demo or error notification
            postsDataType0.add(PostModel.demo()); // Adjust this based on your implementation
            userDataType0.add(UserModel.demo()); // Adjust this based on your implementation
          }
        }

        // Similar error handling for type1Notifications and type2Notifications

        Utils.MSG_Debug("Number of notifications: ${notifications.length}");
        Utils.MSG_Debug(
            "Number of type 0 notifications: ${type0Notifications.length}");
        Utils.MSG_Debug(
            "Number of type 1 notifications: ${type1Notifications.length}");
        Utils.MSG_Debug(
            "Number of type 2 notifications: ${type2Notifications.length}");

        setState(() {
          _dataLoaded = true;
          _isLoading = false;
          loadedNotificationsAll = notifications;

          loadedNotificationsType0 = type0Notifications;
          loadedNotificationsType1 = type1Notifications;
          loadedNotificationsType2 = type2Notifications;

          loadedPostsType0 = postsDataType0;
          loadedPostsType1 = postsDataType1;
          loadedPostsType2 = postsDataType2;

          loadedUserDataType0 = userDataType0;
          loadedUserDataType1 = userDataType1;
          loadedUserDataType2 = userDataType2;
        });

        Utils.MSG_Debug("Data loaded successfully");
      } else {
        List<NotificationModel> notifications =
            (jsonDecode(notifsJson!) as List)
                .map((json) => NotificationModel.fromJson(json))
                .toList();

        // Separate notifications based on type
        List<NotificationModel> type0Notifications =
            notifications.where((notif) => notif.type == 0).toList();
        List<NotificationModel> type1Notifications =
            notifications.where((notif) => notif.type == 1).toList();
        List<NotificationModel> type2Notifications =
            notifications.where((notif) => notif.type == 2).toList();

        Utils.MSG_Debug("Number of notifications: ${notifications.length}");
        Utils.MSG_Debug("Number of type 0 notifications: ${type0Notifications.length}");
        Utils.MSG_Debug("Number of type 1 notifications: ${type1Notifications.length}");
        Utils.MSG_Debug("Number of type 2 notifications: ${type2Notifications.length}");

        setState(() {
          _dataLoaded = true;
          _isLoading = false;
          loadedNotificationsAll = notifications;
          loadedNotificationsType0 = type0Notifications;
          loadedNotificationsType1 = type1Notifications;
          loadedNotificationsType2 = type2Notifications;
        });

        Utils.MSG_Debug("Data loaded successfully");
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
                color: Theme.of(context).colorScheme.secondary),
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
            length: 4,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: AppBar(
                  bottom: const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: ("All"),),  /// management
                      Tab(text: ("Requests"),),  /// management
                      Tab(text: ("Likes"),),  /// management
                      Tab(text: ("Accepted"),)  /// management
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
                  // Content for the "Accepted Requests" tab
                  _buildAcceptedTab()
                ],
              ),
            ),
          ),
        ),
      ),
    );});
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
              child: Text("Error loading data"),  /// management
            );
          } else {
            return Container(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : loadedNotificationsAll.isEmpty
                      ? Center(
                          child: Text(
                            Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", "0 Notifications!",),),)
                      : ListView.builder(
                          itemCount: loadedNotificationsAll.length,
                          itemBuilder: (context, index) {
                            String notificationText;

                            // Determine the text based on the type
                            if (loadedNotificationsAll[index].type == 0) {
                              notificationText = "New Notification!";  /// management
                            } else if (loadedNotificationsAll[index].type == 1) {
                              notificationText = "New Notification!";  /// management
                            }
                            else if (loadedNotificationsAll[index].type == 2) {
                              notificationText = "New Notification!";  /// management
                            } else {
                              // Handle other types or provide a default text
                              notificationText = "New notification!";  /// management
                            }

                            return Hero(
                              tag: 'userHero${loadedNotificationsAll[index].fromUid}',
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
                                          Text(Utils.formatTimeDifference(loadedNotificationsAll[index].date)),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {},
                                      title: Text(
                                        loadedNotificationsAll[index].fromUid,
                                        style: Theme.of(context).textTheme.titleMedium,),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 8),
                                          buildSubtitle("TEXT", loadedNotificationsAll[index].type),
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
    return Builder(builder: (BuildContext context) {
      return FutureBuilder(
        future: _dataLoaded ? null : getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,),
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
                  : loadedNotificationsType0.isEmpty && loadedUserDataType0.isEmpty
                  ? Center(
                child: Text(
                  Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", "No Users!",),),)
                  : ListView.builder(
                itemCount: loadedNotificationsType0.length,
                itemBuilder: (context, index) {
                  NotificationModel notification = loadedNotificationsType0[index];
                  return Hero(
                    tag: 'userHero${notification.fromUid}',
                    child: Card(
                      shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.zero,),
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.all(8.0),
                            child: Row(children: [
                                const SizedBox(width: 10),
                                Text("New Notification!"),
                                const Spacer(),
                                Text(Utils.formatTimeDifference(notification.date)),
                              ],),),
                          ListTile(
                            onTap: () {
                            },
                            title: Text(
                              "${loadedUserDataType0[index].fullName} requested Carpool from you!", /// management
                              style: Theme.of(context).textTheme.titleMedium,),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                buildSubtitle(loadedUserDataType0[index].username,notification.type),
                                Text("Trip: "),
                                Text("${loadedPostsType0[index].date} "
                                    "${Ref_Window.Ref_Management.SETTINGS.Get("WND_NOTIFICATIONS_TEXT_FROM", "from ")}"
                                    "${loadedPostsType0[index].startLocation} "
                                    "${Ref_Window.Ref_Management.SETTINGS.Get("WND_NOTIFICATIONS_TEXT_TO", " to  ")}"
                                    "${loadedPostsType0[index].endLocation}"),
                                Text("${Ref_Window.Ref_Management.SETTINGS.Get("WND_NOTIFICATIONS_TEXT_FREE_SPACE", "seats left ")}"
                                    "${loadedPostsType0[index].freeSeats}/${loadedPostsType0[index].totalSeats}")
                              ],),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                color: Theme.of(context).colorScheme.onPrimary,
                                icon: const Icon(Icons.check),
                                onPressed: () {
                                  postFirestore.toggleRequestCarpool(currentUserUID, loadedNotificationsType0[index].fromUid, loadedNotificationsType0[index].pid, 1, loadedPostsType0[index]);
                                  UtilsFlutter.MSG("REQUEST ACCEPTED, NOTIFICATION SENT", context);
                                  postFirestore.updateNotificationSeenStatus(currentUserUID, loadedNotificationsType0[index].nid, true);
                                },
                              ),
                              IconButton(
                                color: Theme.of(context).colorScheme.onPrimary,
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  postFirestore.toggleRequestCarpool(currentUserUID, loadedNotificationsType0[index].fromUid, loadedNotificationsType0[index].pid, 0, loadedPostsType0[index]);
                                  UtilsFlutter.MSG("REQUEST DENIED, NOTIFICATION SENT", context);
                                  postFirestore.updateNotificationSeenStatus(currentUserUID, loadedNotificationsType0[index].nid, true);
                                },
                              ),
                            ],
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

  /// TYPE 1
  Widget _buildAcceptedTab() {
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
                  : loadedNotificationsType1.isEmpty
                  ? Center(
                child: Text(
                  Ref_Window.Ref_Management.SETTINGS.Get("JNL_HOME_TITLE_1", "No Users!",),
                ),
              )
                  : ListView.builder(
                itemCount: loadedNotificationsType1.length,
                itemBuilder: (context, index) {
                  // Access notification details based on the type 0 list
                  NotificationModel notification = loadedNotificationsType1[index];
                  return Hero(
                    tag: 'userHero${notification.fromUid}',
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
                                Text("New Notification!"),
                                const Spacer(),
                                Text(Utils.formatTimeDifference(notification.date)),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              // Handle onTap for type 1
                              // For example, navigate to a details screen
                            },
                            title: Text(
                              "${loadedUserDataType1[index].fullName} sent you a carpool request!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [SizedBox(height: 8), buildSubtitle(loadedUserDataType1[index].username, notification.type),],),
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

  /// TYPE 2
  Widget _buildLikesTab() {
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
                  : loadedNotificationsType2.isEmpty
                  ? Center(
                child: Text(
                  Ref_Window.Ref_Management.SETTINGS.Get("WND_NOTIFICATIONS_NO_NOTIFICATIONS", "0 Notifications!",),),)  /// management
                  : ListView.builder(
                itemCount: loadedNotificationsType2.length,
                itemBuilder: (context, index) {
                  NotificationModel notification = loadedNotificationsType2[index];

                  return Hero(
                    tag: 'userHero${notification.fromUid}',
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
                                Text("New Notification!"),  /// management
                                const Spacer(),
                                Text(Utils.formatTimeDifference(notification.date)),
                              ],
                            ),
                          ),
                          ListTile(
                            onTap: () {
                              // Handle onTap for type 0
                              // For example, navigate to a details screen
                            },
                            title: Text(
                              "${loadedUserDataType2[index].fullName} sent you a carpool request!",  /// management
                              style: Theme.of(context).textTheme.titleMedium,),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                buildSubtitle(loadedUserDataType2[index].username, notification.type),
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
          child: Text("@$text has requested a carpool!"),  /// management
        );
      case 1:
        return GestureDetector(
          onTap: () {},
          child: Text("@$text has accepted the request you sent!"),  /// management
        );
      case 2:
        return GestureDetector(
          onTap: () {},
          child: Text("@$text liked your post"),  /// management
        );
      default:
        return Text("Default content");  /// management
    }
  }

//--------------
//--------------
}
