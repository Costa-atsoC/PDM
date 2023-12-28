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
  List<Map<String, dynamic>> myData = [];
  final formKey = GlobalKey<FormState>();

  List<NotificationModel> loadedNotifications = [];
  List<UserModel> loadedUsers = [];
  List<PostModel> loadedPosts = [];

  // STORING THE PROFILE IMAGES
  List<Map<String, dynamic>> loadedImages = [];
  // STORING THE PROFILE IMAGES FROM THE POST USERS
  List<Map<String, dynamic>> loadedImagesUser = [];

  bool _dataLoaded = false;
  bool _isLoading = true;

  Widget _buildNotificationsPage(){
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _dataLoaded = false;
          });
          await getData();
        },
        child: Builder(
          builder: (BuildContext context) {
            return FutureBuilder(
              future: _dataLoaded ? null : getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                      //minHeight: 15,
                    ),
                  );
                } else if (snapshot.hasError) {
                  Utils.MSG_Debug("Error: ${snapshot.error}");
                  return Center(
                    child: Text("Error loading data"),
                  );
                } else {
                  String? currentUserUID =
                      FirebaseAuth.instance.currentUser?.uid;

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
                          if (loadedNotifications[index].type ==
                              0) {
                            notificationText =
                            "@${loadedUsers[index].username} sent you a carpool request!";
                          } else if (loadedNotifications[index]
                              .type ==
                              1) {
                            notificationText =
                            "@${loadedUsers[index].username} accepted your request!";
                          } else if (loadedNotifications[index]
                              .type ==
                              2) {
                            notificationText =
                            "@${loadedUsers[index].username} liked your post!";
                          } else {
                            // Handle other types or provide a default text
                            notificationText = "New notification!";
                          }
                          return Hero(
                            tag:
                            'userHero${loadedUsers[index].uid}',
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
                                        /* CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: NetworkImage(
                                                        loadedImages.isNotEmpty
                                                            ? loadedImages[index]["url"]
                                                            : 'http://www.gravatar.com/avatar/3b3be63a4c2a439b013787725dfce802?d=identicon',
                                                      ),
                                                    ),

                                                    */
                                        const SizedBox(width: 10),
                                        Text("New notification!"),
                                        Spacer(),
                                        Text(Utils
                                            .formatTimeDifference(
                                            loadedNotifications[
                                            index]
                                                .date)),
                                      ],
                                    ),
                                  ),
                                  // Add more user details as needed
                                  ListTile(
                                    onTap: () {
                                      modalProfile.show(context,Ref_Window.Ref_Management, loadedUsers[index], loadedImages[index]);
                                    },
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
                                        // Add some spacing
                                        buildSubtitle(
                                            loadedNotifications[
                                            index]
                                                .type,
                                            loadedPosts[index],
                                            loadedUsers[index],
                                            loadedImagesUser[index]),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ));
                }
              },
            );
          },
        ),
      ),
    );
  }


  //------ END OF DATABASE
  Future getData() async {
    String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    if (_dataLoaded) {
      return; // Skip fetching data if it's already loaded
    }
    try {
      String currentUserUID = FirebaseAuth.instance.currentUser?.uid ?? '';
      List<NotificationModel> newNotifications =
      await PostFirestore().getUserNotifications(currentUserUID);

      List<UserModel> newUsers = [];
      List<PostModel> newPosts = [];
      Map<int, List<Map<String, dynamic>>> postImagesMap = {};
      Map<int, List<Map<String, dynamic>>> postImagesMapUser = {};


      for (int i = 0; i < newNotifications.length; i++) {

        String uid = newNotifications[i].toUid;
        String fromUid = newNotifications[i].fromUid;
        String pid = newNotifications[i].pid;

        UserModel? user = await userFirestore.getUserData(fromUid);
        newUsers.add(user!);

        PostModel? post = await PostFirestore().getPostByPid(uid, pid);
        newPosts.add(post!);

        List<Map<String, dynamic>> images =
        await Ref_Window.Ref_FirebaseStorage.loadImages(fromUid);
        postImagesMap[i] = images;

        if (images.isNotEmpty) {
          Map<String, dynamic> firstImage = images.first;
          loadedImages.add(firstImage);
        }

        List<Map<String, dynamic>> imagesUser =
        await Ref_Window.Ref_FirebaseStorage.loadImages(uid);
        postImagesMapUser[i] = imagesUser;

        if (imagesUser.isNotEmpty) {
          Map<String, dynamic> firstImageUser = imagesUser.first;
          loadedImagesUser.add(firstImageUser);
        }
      }

      setState(() {
        loadedNotifications.clear();
        loadedNotifications.addAll(newNotifications);
        loadedUsers.clear();
        loadedUsers.addAll(newUsers);
        loadedPosts.clear();
        loadedPosts.addAll(newPosts);

        loadedImages.clear();
        for (int i = 0; i < newPosts.length; i++) {
          List<Map<String, dynamic>> images = postImagesMap[i] ?? [];
          loadedImages.addAll(images);
        }
        loadedImagesUser.clear();
        for (int i = 0; i < newPosts.length; i++) {
          List<Map<String, dynamic>> imagesUser = postImagesMapUser[i] ?? [];
          loadedImagesUser.addAll(imagesUser);
        }
      });

      setState(() {
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
    if (!_dataLoaded) {
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
      home: _buildNotificationsPage(),
    );
  }

//--------------
  Widget buildSubtitle(int notificationType, PostModel post, UserModel user,
      Map<String, dynamic> image) {
    switch (notificationType) {
      case 0:
        return GestureDetector(
          onTap: () {
            modalPost.show(context, post, user, image);
          },
          child: Text("Trip: ${post.startLocation} to ${post.endLocation}, ${post.date}\nClick here to see the post"),
        );
      case 1:
        return GestureDetector(
          onTap: () {
            modalPost.show(context, post, user, image);
          },
          child:Text("Trip: ${post.startLocation} to ${post.endLocation}, ${post.date}\nClick here to see the post"),
        );
      case 2:
        return GestureDetector(
          onTap: () {
            modalPost.show(context, post, user, image);
          },
          child: Text("Trip: ${post.startLocation} to ${post.endLocation}, ${post.date}\nClick here to see the post"),
        );
      // Add more cases as needed
      default:
        return Text("Default content");
    }
  }

//--------------
//--------------
}
