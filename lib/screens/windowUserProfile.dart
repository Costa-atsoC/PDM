import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ubi/common/Drawer.dart';
import 'package:ubi/firebase_auth_implementation/models/post_model.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import 'package:path/path.dart' as path;
import 'package:ubi/firestore/firebase_storage.dart';
import 'package:ubi/firestore/user_firestore.dart';
import '../common/widgets/modals/modalUpdateUser.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/widgets/modals/modalUpdatePost.dart';
import '../firestore/post_firestore.dart';
import '../main.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowUserProfile extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();
  final UserFirestore userFirestore = UserFirestore();
  int? ACCESS_WINDOW_PROFILE;

  UserModel user;

  //--------------
  windowUserProfile(this.Ref_Management, this.user) {
    windowTitle = "General Window";
    user = this.user;
    //Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {
    //Utils.MSG_Debug(windowTitle + ":Load");
    ACCESS_WINDOW_PROFILE = await Ref_Management.Get_SharedPreferences_INT(
        "WND_PROFILE_ACCESS_NUMBER");
    Ref_Management.Save_Shared_Preferences_INT(
        "WND_PROFILE_ACCESS_NUMBER", ACCESS_WINDOW_PROFILE! + 1);
  }

  //--------------
  @override
  State<StatefulWidget> createState() {
    //Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowUserProfile(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowUserProfile extends State<windowUserProfile> {
  final windowUserProfile Ref_Window;
  String className = "";

  //--------------
  State_windowUserProfile(this.Ref_Window) : super() {
    className = "State_windowGeneral";
    //Utils.MSG_Debug("$className: createState");
  }

  //--------------
  @override
  void dispose() {
    //Utils.MSG_Debug("createState");
    super.dispose();
    //Utils.MSG_Debug("$className:dispose");
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
    //Utils.MSG_Debug("$className: initState");
    super.initState();
    Ref_Window.Ref_Management.saveNumAccess("NUM_ACCESS_WND_PROFILE");
    _refreshData();
  }

  // void NavigateTo_New_Window(context) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               windowUserProfile(Ref_Window.Ref_Management)));
  // }

  //--- database constants
  // All data
  List<PostModel> userData = [];
  final formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool isOnline = false;

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final List<PostModel> data =
        await PostFirestore().getUserPosts(widget.user.uid);
    isOnline = await userFirestore.isUserOnline(widget.user);
    setState(() {
      userData.addAll(data);
      _isLoading = false;
    });
    for (var i = 0; i < userData.length; i++) {
      Utils.MSG_Debug("DATA: ${userData[i].title}");
    }
  }

  //------ end of database constants

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();
    String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    Widget userAction = const SizedBox.shrink();
    if (widget.user.uid ==
        Ref_Window.Ref_Management.SETTINGS.Get("WND_USER_PROFILE_UID", "-1")) {
      userAction = IconButton(
        icon: const Icon(Icons.settings),
        color: Colors.white,
        onPressed: () {
          modalUpdateUser.show(context, widget.user);
        },
      );
    }
    //Utils.MSG_Debug("$className: build");
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        drawer: CustomDrawer(Ref_Window.Ref_Management),
        appBar: AppBar(
          title: Text(Ref_Window.Ref_Management.SETTINGS
              .Get("WND_PROFILE_TITLE_1", "User Profile"), style: Theme.of(context).textTheme.titleMedium,),
          actions: [userAction],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //Profile Picture
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Expanded(
                    child: FutureBuilder(
                      future: Ref_Window.Ref_FirebaseStorage.loadImages(
                          widget.user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(color: Theme.of(context).iconTheme.color,),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong!'),
                          );
                        } else if (snapshot.hasData) {
                          final List<Map<String, dynamic>> images =
                              snapshot.data ?? [];
                          if (images.isNotEmpty) {
                            final Map<String, dynamic> firstImage =
                                images.first;

                            if (widget.user.uid ==
                                Ref_Window.Ref_Management.SETTINGS
                                    .Get("WND_USER_PROFILE_UID", "-1")) {
                              return SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 100,
                                      backgroundImage: NetworkImage(firstImage['url']),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                        child:  Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.add_a_photo_sharp, size: 40, color: Theme.of(context).scaffoldBackgroundColor),
                                            onPressed: () {
                                              Ref_Window.Ref_FirebaseStorage.upload("gallery", widget.user.uid);
                                            },
                                            label: const Text(""),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                                              shadowColor: Colors.transparent,
                                              padding: EdgeInsets.only(left: 2, bottom: 2),
                                            ),
                                          ),
                                        ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(17.0), // Add padding to move the button to the right
                                        child: Tooltip(
                                          message: isOnline ? 'Online' : 'Last Seen',
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isOnline ? Colors.green : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            }
                            return SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(children: [
                                  CircleAvatar(
                                      radius: 100,
                                      backgroundImage:
                                          NetworkImage(firstImage['url'])),
                                  Stack(
                                    children: [
                                      Container(
                                        color: Colors.transparent, // Set the container to be transparent
                                        width: 100,
                                        height: 100,
                                      ),
                                      Positioned(
                                        left: 0, // Align the circle to the left
                                        top: 0, // Align the circle to the top
                                        child: Tooltip(
                                          message: isOnline ? 'Online' : 'Last Seen',
                                          child: Container(
                                            width: 20, // Set the width of the circle
                                            height: 20, // Set the height of the circle
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isOnline ? Colors.green : Colors.grey, // Use green for online, grey for offline
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: CircleAvatar(
                                      radius: 100,
                                      backgroundImage:
                                          NetworkImage(firstImage['url']),
                                    ),
                                  ),
                                ]));
                          }
                        }
                        if (widget.user.uid ==
                            Ref_Window.Ref_Management.SETTINGS
                                .Get("WND_USER_PROFILE_UID", "-1")) {
                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          isOnline ? Colors.green : Colors.grey,
                                      // Use green for online, grey for offline
                                      borderRadius: BorderRadius.circular(180),
                                    ),
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.add_a_photo_sharp),
                                      onPressed: () {
                                        Ref_Window.Ref_FirebaseStorage.upload(
                                            "gallery", widget.user.uid);
                                      },
                                      label: const Text(""),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage(
                                        "assets/PORSCHE_MAIN_2.jpeg"),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox(
                          width: 200,
                          height: 200,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage("assets/niko.jpg"),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  widget.user.username,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleSmall?.color,
                  ),
                ),
                Text(
                  widget.user.location,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.titleSmall?.color,
                    fontSize: 25,
                  ),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  "@${widget.user.fullName}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ]),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    Ref_Window.Ref_Management.SETTINGS
                        .Get("WND_USER_PROFILE_MEM", "Member:"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  ),
                  Text(
                    widget.user.registerDate,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    Ref_Window.Ref_Management.SETTINGS.Get(
                        "WND_USER_PROFILE_LAST_ONLINE", "Last time online:"),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  ),
                  Text(
                    widget.user.lastLogInDate,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3 - 30,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : userData.isEmpty
                        ? const Center(child: Text("No Data Available!!!"))
                        : ListView.builder(
                            itemCount: userData.length,
                            itemBuilder: (context, index) {
                              return Hero(
                                tag: 'postHero${userData[index].pid}',
                                child: Card(
                                  child: ListTile(
                                      title: Text(userData[index].title),
                                      subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(userData[index].date),
                                            Text(
                                                "from: ${userData[index].startLocation} to: ${userData[index].endLocation}"),
                                            Text(userData[index].freeSeats +
                                                "/" +
                                                userData[index].totalSeats +
                                                " FREE SEATS"),
                                            Text(userData[index].description),
                                          ]),
                                      trailing: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            userData[index].uid ==
                                                    currentUserUID
                                                ? IconButton(
                                                    icon:
                                                        const Icon(Icons.edit),
                                                    onPressed: () async {
                                                      Ref_Window.Ref_Management.saveNumAccess("NUM_ACCESS_BTN_UPDATE_POST");
                                                      ModalUpdatePost.show(
                                                          context,
                                                          userData[index]);
                                                      setState(() {});
                                                    },
                                                  )
                                                : const SizedBox(),
                                            userData[index].uid ==
                                                    currentUserUID
                                                ? IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.redAccent,
                                                    ),
                                                    onPressed: () {
                                                      // Show a confirmation dialog
                                                      Ref_Window.Ref_Management.saveNumAccess("NUM_ACCESS_BTN_DELETE_POST");
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                'Confirm Delete'),
                                                            content: const Text(
                                                                'Are you sure you want to delete this post?'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child: const Text(
                                                                    'Cancel'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  // Close the dialog and delete the post
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  PostFirestore().deletePost(
                                                                      currentUserUID!,
                                                                      userData[
                                                                              index]
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
                                                  )
                                                : const SizedBox()
                                          ],
                                        ),
                                      )),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
//--------------
//--------------
//--------------
}
