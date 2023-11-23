import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../Utils.dart';

class PostFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePostData(PostModel post, String uid) async {
    try {
      await _firestore.collection('users').doc(uid).collection('posts').doc(post.pid).set({
        'uid': post.uid,
        'pid': post.pid,
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
    } catch (error) {
      Utils.MSG_Debug('Error saving post data: $error');
    }
  }

  Future<List<PostModel>> getUserPosts(String uid) async {
    List<PostModel> userPosts = [];

    try {
      print('Before fetching user document');
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection('users').doc(uid).get();
      print('After fetching user document');

      if (userDoc.exists) {
        print('Before fetching posts');
        QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(uid).collection('posts').get();
        print('After fetching posts');


        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          var data = doc.data();
          PostModel post = PostModel(
            uid: data['uid'],
            pid: data['pid'],
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

  Future<List<PostModel>> getAllPosts() async {
    List<PostModel> allPosts = [];

    try {
      // Use collectionGroup to query posts across all users
      QuerySnapshot<Map<String, dynamic>> postsSnapshot =
      await _firestore.collectionGroup('posts').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> postDoc in postsSnapshot.docs) {
        var data = postDoc.data();
        PostModel post = PostModel(
          uid: data['uid'],
          pid: data['pid'],
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
    return allPosts;
  }



}
