/*
UNDER DEVELOPMENT
 */

import 'package:firebase_messaging/firebase_messaging.dart';

void sendNotificationToOwner(String ownerToken, String likedUserName) async {
  await FirebaseMessaging.instance.subscribeToTopic('post_$ownerToken');

  /*await FirebaseMessaging.instance.send(
    RemoteMessage(
      data: <String, String>{
        'title': 'New Like!',
        'body': '$likedUserName liked your post.',
      },
      to: ownerToken, // Use the FCM token of the post owner here
    ),
  );
   */
}

