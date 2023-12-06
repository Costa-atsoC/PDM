import 'dart:io' as io;
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

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../common/widgets/modals/modalUpdatePost.dart';
import '../firestore/post_firestore.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowUserProfile extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();
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

  // This function is used to fetch all data from the database
  void _refreshData() async {
    final List<PostModel> data = await PostFirestore().getUserPosts(widget.user.uid);
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
    String? currentUserUID =
        FirebaseAuth.instance.currentUser?.uid;

    //Utils.MSG_Debug("$className: build");
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        drawer: CustomDrawer(Ref_Window.Ref_Management),
        appBar: AppBar(
          title: Text(Ref_Window.Ref_Management.SETTINGS
              .Get("WND_PROFILE_TITLE_1", "User Profile")),
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
                      future: Ref_Window.Ref_FirebaseStorage.loadImages(widget.user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong!'),
                          );
                        } else if (snapshot.hasData) {
                          final List<Map<String, dynamic>> images = snapshot.data ?? [];
                          if (images.isNotEmpty) {
                            final Map<String, dynamic> firstImage = images.first;

                            if(widget.user.uid == Ref_Window.Ref_Management.SETTINGS.Get("WND_USER_PROFILE_UID", "-1")){
                              return SizedBox(
                                width: 200,
                                height: 200,
                                child:
                                Stack(
                                  children: <Widget>[
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.circular(100)
                                            ),
                                            child: ElevatedButton.icon(
                                              icon: const Icon(
                                                  Icons.add_a_photo_sharp),
                                              onPressed: () {
                                                Ref_Window.Ref_FirebaseStorage.upload("gallery", widget.user.uid);
                                              },
                                              label: const Text(""),
                                            )
                                        )
                                    ),
                                    SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: CircleAvatar(
                                        radius: 100,
                                            backgroundImage: NetworkImage(firstImage['url']),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(firstImage['url'])
                              ),
                            );
                          }
                        }
                        if(widget.user.uid == Ref_Window.Ref_Management.SETTINGS.Get("WND_USER_PROFILE_UID", "-1")){
                          return SizedBox(
                            width: 200,
                            height: 200,
                            child:
                            Stack(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                                100)
                                        ),
                                        child: ElevatedButton.icon(
                                          icon: const Icon(
                                              Icons.add_a_photo_sharp),
                                          onPressed: () {
                                            Ref_Window.Ref_FirebaseStorage.upload(
                                                "gallery", widget.user.uid);
                                          },
                                          label: const Text(""),
                                        )
                                    )
                                ),
                                const SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: CircleAvatar(
                                    radius: 100,
                                    backgroundImage: AssetImage(
                                        "assets/niko.jpg"),
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
                              backgroundImage: AssetImage(
                                  "assets/niko.jpg"),
                            ),
                          );
                      },
                    ),
                  ),
                ),
      ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

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
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Ref_Window.Ref_Management.SETTINGS.Get("WND_USER_PROFILE_MEM", "Member:"),
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height/3 - 30,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(userData[index].date),
                                          Text("from: ${userData[index].startLocation} to: ${userData[index].startLocation}"),
                                          Text(userData[index].freeSeats + "/"+ userData[index].totalSeats + " FREE SEATS"),
                                          Text(userData[index].description),
                                        ]),
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          userData[index].uid == currentUserUID
                                              ? IconButton(
                                                  icon: const Icon(Icons.edit),
                                            onPressed: () async {
                                              ModalUpdatePost.show(
                                                  context,
                                                  userData[
                                                  index]);
                                              setState(() {});
                                            },

                                                )
                                              : const SizedBox(),
                                          userData[index].uid == currentUserUID
                                              ? IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.redAccent,),
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
                                                              userData[index]
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
