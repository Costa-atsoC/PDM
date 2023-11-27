import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase_auth_implementation/models/post_model.dart';
import '../../firestore/user_firestore.dart';

class DetailScreen extends StatelessWidget {
  final PostModel post;

  const DetailScreen({required this.post});

  // Method to show the DetailScreen as a modal bottom sheet
  static void show(BuildContext context, PostModel post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent, // Optional: Make the background transparent
          child: DetailScreen(post: post),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserFirestore userFirestore = UserFirestore();
    String? currentUserUID = FirebaseAuth.instance.currentUser?.uid;

    double modalHeight = MediaQuery.of(context).size.height * 0.55;
    double topBottomPadding = (MediaQuery.of(context).size.height - modalHeight) / 6;

    return Container(
      color: Colors.transparent,
      child: Center(
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          margin: const EdgeInsets.all(15),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, topBottomPadding, 16, topBottomPadding),
            height: modalHeight,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/PORSCHE_MAIN_2.jpeg'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: FutureBuilder<String>(
                          future: userFirestore.getUserAttribute(
                            post.uid,
                            'fullName',
                          ),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return Text("User: Loading...");
                            } else if (userSnapshot.hasError) {
                              return Text("User: Error loading user data");
                            } else {
                              String fullName = userSnapshot.data ?? "Unknown";
                              return Text(
                                "User: $fullName",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      post.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${post.date}",
                          style: TextStyle(fontSize: 16),
                        ),
                        FutureBuilder<String>(
                          future: userFirestore.getUserAttribute(
                            post.uid,
                            'fullName',
                          ),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return Text("User: Loading...", style: TextStyle(fontSize: 16));
                            } else if (userSnapshot.hasError) {
                              return Text("User: Error loading user data", style: TextStyle(fontSize: 16));
                            } else {
                              String fullName = userSnapshot.data ?? "Unknown";
                              return Text("User: $fullName", style: TextStyle(fontSize: 16));
                            }
                          },
                        ),
                        Text("Description: ${post.description}", style: TextStyle(fontSize: 16)),
                        Text("Free Seats: ${post.freeSeats}/${post.totalSeats}", style: TextStyle(fontSize: 16)),
                        Text("UID: ${post.uid}", style: TextStyle(fontSize: 16)),
                        Text("Location: ${post.location}", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (currentUserUID == post.uid) ...[
                        IconButton(
                            color: Theme.of(context).colorScheme.onPrimary,
                            icon: const Icon(Icons.edit),
                            onPressed: () => {} //showMyForm(post.pid as int?),
                        ),
                        IconButton(
                          color: Colors.red[300],
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Handle delete functionality
                          },
                        ),
                      ] else ...[
                        IconButton(
                          color: Theme.of(context).colorScheme.onPrimary,
                          icon: const Icon(Icons.thumb_up),
                          onPressed: () {
                            // Handle like functionality
                          },
                        ),
                        IconButton(
                          color: Theme.of(context).colorScheme.onPrimary,
                          icon: const Icon(Icons.message),
                          onPressed: () {
                            // Handle message functionality
                          },
                        ),
                      ],
                      // Add more buttons as needed
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
