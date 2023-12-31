import 'dart:io' as io;
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubi/firebase_auth_implementation/models/post_model.dart';
import 'package:path/path.dart' as path;
import 'package:ubi/firestore/firebase_storage.dart';
import 'package:ubi/firestore/user_firestore.dart';
import 'package:uuid/uuid.dart';

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../firebase_auth_implementation/models/comment_model.dart';
import '../firestore/post_firestore.dart';
import '../main.dart';

//----------------------------------------------------------------
//----------------------------------------------------------------
class windowFullPost extends StatefulWidget {
  String windowTitle = "";
  final Management Ref_Management;
  final firebaseStorage Ref_FirebaseStorage = firebaseStorage();
  int? ACCESS_WINDOW_PROFILE;

  PostModel post;

  //--------------
  windowFullPost(this.Ref_Management, this.post) {
    windowTitle = "General Window";
    post = this.post;
    //Utils.MSG_Debug(windowTitle);
  }

  //--------------
  Future<void> Load() async {}

  //--------------
  @override
  State<StatefulWidget> createState() {
    //Utils.MSG_Debug(windowTitle + ":createState");
    return State_windowFullPost(this);
  }
//--------------
}

//----------------------------------------------------------------
//----------------------------------------------------------------
// ignore: camel_case_types
class State_windowFullPost extends State<windowFullPost> {
  final windowFullPost Ref_Window;
  String className = "";

  //--------------
  State_windowFullPost(this.Ref_Window) : super() {
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
    Ref_Window.Ref_Management.saveNumAccess("NUM_ACCESS_WND_PROFILE");
  }

  bool isOnline = false;
  bool _isLoading = true;
  List<commentModel> comments = [];
  List<String> commentersName = [];

  // This function is used to fetch all data from the database
  void _refreshData() async {
    isOnline = await userFirestore.isUserOnline(widget.post.uid);
    comments = await postFirestore.getComments(widget.post);
    for (var i = 0; i < comments.length; i++) {
      commentersName.add(
          await UserFirestore().getUserAttribute(comments[i].cid, "username"));
    }
    setState(() {
      _isLoading = false;
    });
  }

  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  Widget _commentsSection() {
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return Hero(
            tag: 'reviewHero${comments[index].id}',
            child: Card(
                child: ListTile(
              title: Text(
                commentersName[index],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleSmall?.color,
                ),
              ),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comments[index].comment,
                      style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).textTheme.labelLarge?.color,
                      ),
                    )
                  ]),
              trailing: Text(comments[index].date),
            )));
      },
    );
  }

  //--------------
  @override
  Widget build(BuildContext context) {
    Ref_Window.Ref_Management.Load();
    final TextEditingController _commentController = TextEditingController();
    //Utils.MSG_Debug("$className: build");
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
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
                .Get("WND_FULL_POST_1", "Full Post"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(children: [
                      //Profile Picture
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Expanded(
                          child: FutureBuilder(
                            future: Ref_Window.Ref_FirebaseStorage.loadImages(
                                widget.post.uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).iconTheme.color,
                                  ),
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
                                  if (widget.post.uid ==
                                      Ref_Window.Ref_Management.SETTINGS
                                          .Get("WND_USER_PROFILE_UID", "-1")) {
                                    return GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: ClipOval(
                                                child: Container(
                                                  color: Colors.transparent,
                                                  width: 90,
                                                  // You can adjust the width as needed
                                                  height: 90,
                                                  // You can adjust the height as needed
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    radius: 50,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            firstImage['url']),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Stack(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  firstImage['url']),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  color: Colors.transparent,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                // Add padding to move the button to the right
                                                child: Tooltip(
                                                  message: isOnline
                                                      ? 'Online'
                                                      : 'Last Seen',
                                                  child: Container(
                                                    width: 15,
                                                    height: 15,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: isOnline
                                                          ? Colors.green
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  return SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Stack(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              NetworkImage(firstImage['url']),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            // Add padding to move the button to the right
                                            child: Tooltip(
                                              message: isOnline
                                                  ? 'Online'
                                                  : 'Last Seen',
                                              child: Container(
                                                width: 15,
                                                height: 15,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isOnline
                                                      ? Colors.green
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                              if (widget.post.uid ==
                                  Ref_Window.Ref_Management.SETTINGS
                                      .Get("WND_USER_PROFILE_UID", "-1")) {
                                return SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      const CircleAvatar(
                                        radius: 100,
                                        backgroundImage: AssetImage(
                                            "assets/PROFILE_PICTURE_DEMO.jpeg"),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle,
                                          ),
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.add_a_photo_sharp,
                                                size: 40,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            onPressed: () {
                                              Ref_Window.Ref_FirebaseStorage
                                                  .upload("gallery",
                                                      widget.post.uid);
                                            },
                                            label: const Text(""),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              shadowColor: Colors.transparent,
                                              padding: const EdgeInsets.only(
                                                  left: 2, bottom: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          // Add padding to move the button to the right
                                          child: Tooltip(
                                            message: isOnline
                                                ? 'Online'
                                                : 'Last Seen',
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isOnline
                                                    ? Colors.green
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox(
                                width: 150,
                                height: 150,
                                child: CircleAvatar(
                                  radius: 100,
                                  backgroundImage: AssetImage(
                                      "assets/PROFILE_PICTURE_DEMO.jpeg"),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      //Right side of the Post
                      Container(
                        child: Column(children: [
                          Text(
                            widget.post.userFullName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            "@${widget.post.username}",
                            style: Theme.of(context).textTheme.labelLarge,
                          )
                        ]),
                      ),
                      const Spacer(),
                      Text(Utils.formatTimeDifference(widget.post.registerDate))
                    ]),

                    //Post Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_DATE_TEXT_LABEL", "Date: ")}${widget.post.date}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_FROM_TEXT_LABEL", "FROM ")}${widget.post.startLocation}"
                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_TO_TEXT_LABEL", " TO ")}${widget.post.endLocation}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          "${Ref_Window.Ref_Management.SETTINGS.Get("WND_HOME_POST_FREE_SEATS_TEXT_LABEL", "Free Seats: ")}${widget.post.freeSeats}/${widget.post.totalSeats}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          "${Ref_Window.Ref_Management.SETTINGS.Get("e", "Description: ")}${widget.post.description}",
                          style: Theme.of(context).textTheme.labelLarge,
                        )
                      ],
                    ),

                    Divider(
                      color: Theme.of(context).dividerColor,
                    ),

                    //Comments Section
                    comments.isEmpty
                        ? const SizedBox()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height /
                                            4, // Adjust height as needed
                                  ),
                                  child: _commentsSection()),
                            ],
                          ),

                    const Spacer(),

                    //Write Comment Section
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: Ref_Window.Ref_Management.SETTINGS.Get(
                                  "WND_FULL_POST_COMMENT_TEXT_LABEL",
                                  "Write a comment..."),
                              labelStyle:
                                  Theme.of(context).textTheme.labelLarge,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: formValidator,
                            controller: _commentController,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send,
                              color: Color.fromRGBO(124, 23, 87, 1)),
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              commentModel com = commentModel(
                                  id: const Uuid().v4(),
                                  pid: widget.post.pid,
                                  uid: widget.post.uid,
                                  cid: FirebaseAuth.instance.currentUser!.uid,
                                  date: widget.post.date,
                                  comment: _commentController.text);
                              postFirestore
                                  .saveComment(com)
                                  .then((value) => _refreshData());
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
