import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../firebase_auth_implementation/models/comment_model.dart';
import '../firebase_auth_implementation/models/notification_model.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../common/Utils.dart';

class PostFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePostData(PostModel post, String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('posts')
          .doc(post.pid)
          .set({
        'uid': post.uid,
        'userFullName': post.userFullName,
        'username': post.username,
        'pid': post.pid,
        'likes': post.likes,
        'title': post.title,
        'description': post.description,
        'date': post.date,
        'totalSeats': post.totalSeats,
        'freeSeats': post.freeSeats,
        'location': post.location,
        'startLocation': post.startLocation,
        'endLocation': post.endLocation,
        'registerDate': post.registerDate,
        'lastChangedDate': post.lastChangedDate,
      });

      // Save only the pid in the 'likes' collection
      await _firestore.collection('likes').doc(post.pid).set({
        'pid': post.pid,
        'likes': "0",
      });
    } catch (error) {
      Utils.MSG_Debug('Error saving post data: $error');
    }
  }

  Future<void> updatePostData(PostModel post) async {
    try {
      if (post.pid != null && post.pid.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(post.uid)
            .collection('posts')
            .doc(
              post.pid,
            )
            .update(
          {
            'title': post.title,
            'description': post.description,
            'date': post.date,
            'totalSeats': post.totalSeats,
            'freeSeats': post.freeSeats,
            'location': post.location,
            'startLocation': post.startLocation,
            'endLocation': post.endLocation,
            'lastChangedDate': post.lastChangedDate,
          },
        );

        Utils.MSG_Debug('Post with ID ${post.pid} updated successfully.');
      } else {
        Utils.MSG_Debug('Post ID is null or empty. Update failed.');
      }
    } catch (error) {
      Utils.MSG_Debug('Error updating post data: $error');
    }
  }

  Future<void> deletePost(String uid, String pid) async {
    try {
      // Delete the post document
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('posts')
          .doc(pid)
          .delete();

      // Delete the corresponding likes document
      await _firestore.collection('likes').doc('$pid' + '_' + '$uid').delete();

      Utils.MSG_Debug('Post with ID $pid deleted successfully.');
    } catch (error) {
      Utils.MSG_Debug('Error deleting post: $error');
    }
  }

  Future<List<PostModel>> getUserPosts(String uid) async {
    List<PostModel> userPosts = [];

    try {
      //print('Before fetching user document');
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();
      Utils.MSG_Debug('After fetching user document');

      if (userDoc.exists) {
        print('Before fetching posts');
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .get();
        print('After fetching posts');

        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          var data = doc.data();
          PostModel post = PostModel(
            uid: data['uid'],
            userFullName: data['userFullName'],
            username: data['username'],
            pid: data['pid'],
            likes: data['likes'],
            title: data['title'],
            description: data['description'],
            date: data['date'],
            totalSeats: data['totalSeats'],
            freeSeats: data['freeSeats'],
            location: data['location'],
            startLocation: data['startLocation'],
            endLocation: data['endLocation'],
            registerDate: data['registerDate'],
            lastChangedDate: data['lastChangedDate'],
          );
          userPosts.add(post);
        }
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
      }
    } catch (error) {
      Utils.MSG_Debug('Error getting user posts: $error');
      print('Error getting user posts: $error');
    }

    return userPosts;
  }

  ///----------- USER POSTS ORDERED BY DATE
  Future<List<PostModel>> getUserPostsOrderedByDate(String uid) async {
    List<PostModel> userPosts = [];

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();
      Utils.MSG_Debug('After fetching user document');

      if (userDoc.exists) {
        print('Before fetching posts');
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .orderBy('date',
                descending:
                    true) // Order by date in descending order (newest to oldest)
            .get();
        print('After fetching posts');

        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          var data = doc.data();
          PostModel post = PostModel(
            uid: data['uid'],
            userFullName: data['userFullName'],
            username: data['username'],
            pid: data['pid'],
            likes: data['likes'],
            title: data['title'],
            description: data['description'],
            date: data['date'],
            totalSeats: data['totalSeats'],
            freeSeats: data['freeSeats'],
            location: data['location'],
            startLocation: data['startLocation'],
            endLocation: data['endLocation'],
            registerDate: data['registerDate'],
            lastChangedDate: data['lastChangedDate'],
          );
          userPosts.add(post);
        }
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
      }
    } catch (error) {
      Utils.MSG_Debug('Error getting user posts: $error');
      print('Error getting user posts: $error');
    }

    return userPosts;
  }

  Future<PostModel?> getPostByPid(String uid, String pid) async {
    try {
      // Fetch the specific post document
      DocumentSnapshot<Map<String, dynamic>> postDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('posts')
          .doc(pid)
          .get();

      // Check if the post document exists
      if (postDoc.exists) {
        var data = postDoc.data();
        PostModel post = PostModel(
          uid: data?['uid'],
          userFullName: data?['userFullName'],
          username: data?['username'],
          pid: data?['pid'],
          likes: data?['likes'],
          title: data?['title'],
          description: data?['description'],
          date: data?['date'],
          totalSeats: data?['totalSeats'],
          freeSeats: data?['freeSeats'],
          location: data?['location'],
          startLocation: data?['startLocation'],
          endLocation: data?['endLocation'],
          registerDate: data?['registerDate'],
          lastChangedDate: data?['lastChangedDate'],
        );

        return post;
      } else {
        Utils.MSG_Debug("Post with PID $pid not found for user with UID $uid");
        return null;
      }
    } catch (error) {
      Utils.MSG_Debug('Error getting post by PID: $error');
      print('Error getting post by PID: $error');
      return null;
    }
  }

  Future<List<PostModel>> getAllPosts() async {
    List<PostModel> allPosts = [];

    try {
      // Use collectionGroup to query posts across all users
      QuerySnapshot<Map<String, dynamic>> postsSnapshot =
          await _firestore.collectionGroup('posts').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> postDoc
          in postsSnapshot.docs) {
        var data = postDoc.data();
        PostModel post = PostModel(
          uid: data['uid'],
          userFullName: data['userFullName'],
          username: data['username'],
          pid: data['pid'],
          likes: data['likes'],
          title: data['title'],
          description: data['description'],
          date: data['date'],
          totalSeats: data['totalSeats'],
          freeSeats: data['freeSeats'],
          location: data['location'],
          startLocation: data['startLocation'],
          endLocation: data['endLocation'],
          registerDate: data['registerDate'],
          lastChangedDate: data['lastChangedDate'],
        );
        allPosts.add(post);
      }
    } catch (error) {
      Utils.MSG_Debug('Error getting all posts: $error');
    }

    Utils.MSG_Debug('Fetching posts');
    return allPosts.reversed.toList();
  }

  Future<int> _updatePostLikesCount(
      String uid, String pid, int incrementValue) async {
    try {
      // Get the current likes count as a string
      DocumentSnapshot postSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('posts')
          .doc(pid)
          .get();

      if (postSnapshot.exists) {
        // Convert the likes count to an integer, increment, and update the field
        String currentLikes =
            (postSnapshot.data() as Map<String, dynamic>)['likes'].toString() ??
                '0';
        int updatedLikes = int.parse(currentLikes) + incrementValue;

        await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .doc(pid)
            .update({
          'likes': updatedLikes.toString(),
        });

        return updatedLikes;
        Utils.MSG_Debug(
            'Likes count updated for post with ID $pid in user\'s $uid posts collection. New count: $updatedLikes');
      } else {
        Utils.MSG_Debug(
            'Post document with ID $pid does not exist in user\'s $uid posts collection.');
        return -1;
      }
    } catch (error) {
      Utils.MSG_Debug('Error updating likes count for post: $error');
      return -1;
    }
  }

  Future<bool> getIsLikedStatus(String uid, PostModel post) async {
    try {
      DocumentReference likesRef = _firestore
          .collection('likes')
          .doc(post.pid)
          .collection('users')
          .doc(uid);
      DocumentSnapshot likesSnapshot = await likesRef.get();

      return likesSnapshot.exists &&
          (likesSnapshot.data() as Map<String, dynamic>)['liked'] == 1;
    } catch (error) {
      Utils.MSG_Debug('Error checking like status for post: $error');
      return false;
    }
  }

  Future<int> toggleActionPost(String uid, PostModel post, int type) async {
    // type
    // 0 for user carpool request,
    // 1 is for accepting request,
    // 2 is for liking!
    try {
      if (type == 2) {
        // Check if the user has already liked the post
        bool isLiked = await getIsLikedStatus(uid, post);
        // Toggle the like status
        isLiked = !isLiked;
        // Update the like status in the 'likes' collection
        if (isLiked) {
          // Create a new like document or update existing in the 'likes' collection
          await _firestore
              .collection('likes')
              .doc(post.pid)
              .collection('users')
              .doc(uid)
              .set({
            'liked': 1,
            'seen': '0',
            // Add any other fields needed for likes
          });

          // Increment the likes count on the post
          int updatedLikes = await _updatePostLikesCount(post.uid, post.pid, 1);
          String notificationId = const Uuid().v4();

          // Create a new notification document in the 'notifications' collection
          await _firestore
              .collection('users')
              .doc(post.uid)
              .collection('notifications')
              .doc(notificationId)
              .set({
            'to_uid': post.uid,
            'pid': post.pid,
            'from_uid': uid,
            'type': 2,
            // 0 for user carpool request, the 1 is for accepting request, the 2 is for liking!
            'seen': 0,
            'date': Utils.currentTime(),
            // 0 for not seen, 1 for seen (it will not appear anymore)
          });

          Utils.MSG_Debug(updatedLikes.toString());
          Utils.MSG_Debug("ACTION 2");
          return updatedLikes;
        } else {
          // Delete the like document in the 'likes' collection
          await _firestore
              .collection('likes')
              .doc(post.pid)
              .collection('users')
              .doc(uid)
              .delete();

          // Decrement the likes count on the post
          int updatedLikes =
              await _updatePostLikesCount(post.uid, post.pid, -1);
          Utils.MSG_Debug("ACTION 2");
          return updatedLikes;
        }
      } else {
        // Create a new notification document in the 'notifications' collection
        String notificationId = const Uuid().v4();

        await _firestore
            .collection('users')
            .doc(post.uid)
            .collection('notifications')
            .doc(notificationId)
            .set({
          'id': notificationId,
          'to_uid': post.uid,
          'pid': post.pid,
          'from_uid': uid,
          'type': type,
          // 0 for user carpool request, the 1 is for accepting request, the 2 is for liking!
          'seen': 0,
          // 0 for not seen, 1 for seen (it will not appear anymore)
          'date': Utils.currentTime(),
        });
        Utils.MSG_Debug("ACTION 0 OR 1");
        return -1;
      }
    } catch (error) {
      Utils.MSG_Debug('Error toggling like for post: $error');
      return -1;
    }
  }

  Future<List<NotificationModel>> getUserNotifications(String uid) async {
    try {
      // Query the 'notifications' collection for the specified user ID
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .get();

      // Convert the notification documents to a list of NotificationModel
      List<NotificationModel> notifications = querySnapshot.docs.map((doc) {
        return NotificationModel(
          date: doc['date'],
          toUid: doc['to_uid'],
          pid: doc['pid'],
          type: doc['type'],
          seen: doc['seen'],
          fromUid: doc['from_uid'],
          // Add other attributes as needed
        );
      }).toList();

      return notifications;
    } catch (error) {
      Utils.MSG_Debug('Error fetching user notifications: $error');
      // Return an empty list in case of an error
      return [];
    }
  }

  Future<Map<String, String>> getUserNotificationsJson(String uid) async {
    try {
      Map<String, String> notificationsJsonMap = {
        'notifications': '[]',
      };

      // Query the 'notifications' collection for the specified user ID
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .get();

      // Print the number of documents retrieved
      print('Number of documents: ${querySnapshot.size}');

      // Convert the notification documents to a JSON string
      List<Map<String, dynamic>> notificationDataList = querySnapshot.docs.map((doc) {
        print('Document data: ${doc.data()}');
        return doc.data();
      }).toList();

      if (notificationDataList.isNotEmpty) {
        notificationsJsonMap['notifications'] = jsonEncode(notificationDataList);
      }

      // Print the final JSON string
      print('Final JSON: ${notificationsJsonMap['notifications']}');

      return notificationsJsonMap;
    } catch (error) {
      Utils.MSG_Debug('Error fetching user notifications: $error');
      // Return an empty map in case of an error
      return {
        'notifications': '[]',
      };
    }
  }

  /// METHOD TO CONFIRM OR DENY A CARPOOL REQUEST
  Future<void> toggleRequestCarpool(String fromUid, String toUid, String pid, int request, PostModel post) async {
    // type
    // 0 to deny,
    // 1 to accept,
    try {
      if (request == 1) {
        int freeSeats = int.parse(post.freeSeats);
        if(freeSeats > 0){
          // Create a new notification document in the 'notifications' collection
          String notificationId = const Uuid().v4();

          await _firestore
              .collection('users')
              .doc(toUid)
              .collection('notifications')
              .doc(notificationId)
              .set({
            'id': notificationId,
            'to_uid': toUid,
            'pid': post.pid,
            'from_uid': post.uid,
            'type': 1, // 0 for user carpool request, the 1 is for accepting request, the 2 is for liking!
            'seen': 0,
            // 0 for not seen, 1 for seen (it will not appear anymore)
            'date': Utils.currentTime(),
          });

          Utils.MSG_Debug("Notification Sent to $toUid");

          int updatedSeats = freeSeats - 1;

          await _firestore
              .collection('users')
              .doc(post.uid)
              .collection('posts')
              .doc(
            post.pid,
          )
              .update(
            {
              'title': post.title,
              'description': post.description,
              'date': post.date,
              'totalSeats': post.totalSeats,
              'freeSeats': "$updatedSeats",
              'location': post.location,
              'startLocation': post.startLocation,
              'endLocation': post.endLocation,
              'lastChangedDate': post.lastChangedDate,
            },
          );

          Utils.MSG_Debug('Post with ID ${post.pid} updated successfully.');

        }
      }
    } catch (error) {
      Utils.MSG_Debug('Error toggling like for post: $error');
    }
  }


// disposable
  Future<List<UserModel>> getUsersWhoLikedPost(String pid) async {
    List<UserModel> likedUsers = [];

    try {
      // Query the 'likes' collection for the specified post ID
      QuerySnapshot<Map<String, dynamic>> likesSnapshot = await _firestore
          .collection('likes')
          .where('pid', isEqualTo: pid)
          .get();

      // Iterate through the like documents and retrieve user information
      for (QueryDocumentSnapshot<Map<String, dynamic>> likeDoc
          in likesSnapshot.docs) {
        String uid = likeDoc.data()!['uid'];

        // Retrieve user information for the liked user
        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
            await _firestore.collection('users').doc(uid).get();

        if (userSnapshot.exists) {
          var userData = userSnapshot.data();
          UserModel user = UserModel(
            uid: userData?['uid'],
            email: userData?['email'],
            username: userData?['username'],
            fullName: userData?['fullName'],
            registerDate: userData?['registerDate'],
            lastChangedDate: userData?['lastChangedDate'],
            location: userData?['location'],
            image: userData?['image'],
            online: userData?['online'],
            lastLogInDate: userData?['lastLogInDate'],
            lastSignOutDate: userData?['lastSignOutDate'],
          );
          likedUsers.add(user);
        }
      }
    } catch (error) {
      Utils.MSG_Debug('Error getting users who liked the post: $error');
    }

    return likedUsers;
  }

  Future<String> showLikedUsersNotification(String uid, String pid) async {
    try {
      // Get the list of users who liked the post
      List<UserModel> likedUsers = await getUsersWhoLikedPost(pid);

      // Build a JSON representation of the liked users
      List<Map<String, dynamic>> likedUsersJson = likedUsers
          .map((user) => {
                'uid': user.uid,
                'fullName': user.fullName,
                'username': user.username,
                // Add other user properties you want to include
              })
          .toList();

      // Convert the list to a JSON string
      String notificationJson = json.encode({'likedUsers': likedUsersJson});

      // Update the "seen" field in the likes collection for each user who liked the post
      for (UserModel user in likedUsers) {
        await _firestore
            .collection('likes')
            .doc('$pid' + '_' + '$uid')
            .update({'seen': '1'});
      }

      // Return the generated JSON string
      return notificationJson;
    } catch (error) {
      Utils.MSG_Debug('Error showing liked users notification: $error');
      return ''; // Return an empty string or handle the error as needed
    }
  }

  Future<bool> checkIfPostSeen(String uid, String pid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> likesSnapshot =
          await _firestore.collection('likes').doc('$pid' + '_' + '$uid').get();

      if (likesSnapshot.exists) {
        // Check the "seen" field in the likes document
        bool postSeen =
            (likesSnapshot.data() as Map<String, dynamic>)['seen'] == '1';
        return postSeen;
      } else {
        // The likes document doesn't exist, so the post hasn't been seen
        return false;
      }
    } catch (error) {
      Utils.MSG_Debug('Error checking if post seen: $error');
      return false; // Handle the error by returning false
    }
  }

  Future<List<CommentModel>> getComments(PostModel post) async {
    List<CommentModel> comments = [];

    try {
      // Query the 'likes' collection for the specified post ID
      QuerySnapshot<Map<String, dynamic>> commentsSnapshot = await _firestore
          .collection('users')
          .doc(post.uid)
          .collection('posts')
          .doc(post.pid)
          .collection('comments')
          .get();

      // Iterate through the like documents and retrieve user information
      for (QueryDocumentSnapshot<Map<String, dynamic>> commentDoc
          in commentsSnapshot.docs) {
        var data = commentDoc.data();
        CommentModel comment = CommentModel(
          id: data['id'],
          pid: data['pid'],
          uid: data['uid'],
          cid: data['cid'],
          date: data['date'],
          comment: data['comment'],
        );
        comments.add(comment);
      }
    } catch (error) {
      Utils.MSG_Debug('Error getting comments: $error');
    }

    return comments;
  }

  Future<bool> saveComment(CommentModel comment) async {
    try {
      await _firestore
          .collection('users')
          .doc(comment.uid)
          .collection('posts')
          .doc(comment.pid)
          .collection('comments')
          .doc(comment.id)
          .set({
        'id': comment.id,
        'pid': comment.pid,
        'uid': comment.uid,
        'cid': comment.cid,
        'date': comment.date,
        'comment': comment.comment,
      });
      return true;
    } catch (error) {
      Utils.MSG_Debug('Error saving comment: $error');
      return false;
    }
  }
}
