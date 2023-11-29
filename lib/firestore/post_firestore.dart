import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_auth_implementation/models/post_model.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../common/Utils.dart';

class PostFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePostData(PostModel post, String uid) async {
    try {
      await _firestore.collection('users').doc(uid).collection('posts').doc(post.pid).set({
        'uid': post.uid,
        'pid': post.pid,
        'likes' : post.likes,
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
      // Save post data in the likes collection
      await _firestore.collection('likes').doc(post.pid).set({
        'uid': post.uid,
        'pid': post.pid,
        'liked' : '0',
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
    return allPosts;
  }
  Future<int> toggleLikePost(String uid, PostModel post) async {
    try {
      // Check if the user has already liked the post
      DocumentReference likesRef = _firestore.collection('likes').doc('${post.pid}_${uid}');
      DocumentSnapshot likesSnapshot = await likesRef.get();
      bool isLiked = likesSnapshot.exists &&
          (likesSnapshot.data() as Map<String, dynamic>)['liked'] == 1;

      // Toggle the like status
      isLiked = !isLiked;

      // Update the like status in the likes collection
      if (isLiked) {
        // Create a new like document or update existing
        await likesRef.set({
          'pid': post.pid,
          'uid': uid,
          'liked': 1,
          // Add any other fields needed for likes
        });

        // Increment the likes count on the post
        int updatedLikes = await _updatePostLikesCount(post.uid, post.pid, 1);

        Utils.MSG_Debug(updatedLikes as String);

        return updatedLikes;

      } else {
        // Delete the like document
        await likesRef.delete();

        // Decrement the likes count on the post
        int updatedLikes = await _updatePostLikesCount(post.uid, post.pid, -1);
        return updatedLikes;
      }
    } catch (error) {
      Utils.MSG_Debug('Error toggling like for post: $error');
      return -1;
    }
  }

  Future<int> _updatePostLikesCount(String uid, String pid, int incrementValue) async {
    try {
      // Get the current likes count as a string
      DocumentSnapshot postSnapshot = await _firestore.collection('users').doc(uid).collection('posts').doc(pid).get();

      if (postSnapshot.exists) {
        // Convert the likes count to an integer, increment, and update the field
        String currentLikes = (postSnapshot.data() as Map<String, dynamic>)['likes'].toString() ?? '0';
        int updatedLikes = int.parse(currentLikes) + incrementValue;

        await _firestore.collection('users').doc(uid).collection('posts').doc(pid).update({
          'likes': updatedLikes.toString(),
        });

        return updatedLikes;
        Utils.MSG_Debug('Likes count updated for post with ID $pid in user\'s $uid posts collection. New count: $updatedLikes');
      } else {
        Utils.MSG_Debug('Post document with ID $pid does not exist in user\'s $uid posts collection.');
        return -1;
      }
    } catch (error) {
      Utils.MSG_Debug('Error updating likes count for post: $error');
      return -1;
    }
  }




}