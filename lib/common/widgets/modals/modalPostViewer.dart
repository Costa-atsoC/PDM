import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import '../../../firebase_auth_implementation/models/post_model.dart';

class modalPost extends StatelessWidget {
  final PostModel post;
  final UserModel user;
  final Map<String, dynamic> image;

  const modalPost(
      {required this.post, required this.user, required this.image});

  // Method to show the DetailScreen as a modal bottom sheet
  static void show(
    BuildContext context,
    PostModel post,
    UserModel user,
    Map<String, dynamic> image,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          // Optional: Make the background transparent
          child: modalPost(post: post, user: user, image: image),
        );
      },
    );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(image['url']),
                      ),
                      SizedBox(width: 16),
                      Column(
                        children: [
                          Text(
                            user.fullName,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "@${user.username}",
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
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
