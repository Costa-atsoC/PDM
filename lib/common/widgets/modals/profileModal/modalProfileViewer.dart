import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import '../../../../screens/windowUserProfile.dart';
import '../../../Management.dart';
import '../../../Utils.dart';

class modalProfile extends StatefulWidget {
  final String windowTitle;
  final Management Ref_Management;
  final UserModel user;
  final Map<String, dynamic> image;

  const modalProfile({
    Key? key,
    required this.user,
    required this.image,
    required this.Ref_Management,
  })  : windowTitle = "Search Window",
        super(key: key);

  // Method to show the DetailScreen as a modal bottom sheet
  static void show(
    BuildContext context,
    Management Ref_Management,
    UserModel user,
    Map<String, dynamic> image,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return modalProfile(
          Ref_Management: Ref_Management,
          user: user,
          image: image,
        );
      },
    );
  }

  @override
  _modalProfileState createState() => _modalProfileState();
}

class _modalProfileState extends State<modalProfile> {
  String className = "";

  @override
  void dispose() {
    Utils.MSG_Debug("dispose");
    super.dispose();
    Utils.MSG_Debug("$className:dispose");
  }

  @override
  void deactivate() {
    Utils.MSG_Debug("deactivate");
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    Utils.MSG_Debug("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void initState() {
    className = "State_modalProfile";
    Utils.MSG_Debug("$className: initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    double modalHeight = MediaQuery.of(context).size.height * 0.55;
    double topBottomPadding =
        (MediaQuery.of(context).size.height - modalHeight) / 6;

    return Container(
      color: Colors.transparent,
      child: Center(
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          margin: const EdgeInsets.all(15),
          child: Container(
            padding:
                EdgeInsets.fromLTRB(16, topBottomPadding, 16, topBottomPadding),
            height: modalHeight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(widget.image['url']),
                      ),
                      SizedBox(width: 16),
                      Text(
                        widget.user.fullName,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6?.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "@${widget.user.username}",
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.subtitle1?.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      "From: ${widget.user.location}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => windowUserProfile(
                                    widget.Ref_Management, widget.user),
                              ),
                            );
                          },
                          child: Text("View Profile"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
