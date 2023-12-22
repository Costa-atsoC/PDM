import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubi/firebase_auth_implementation/models/review_model.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../common/Utils.dart';

class UserFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveUserData(UserModel user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var id = user.uid;
    String currTime = Utils.currentTime();
    Utils.MSG_Debug(currTime);

    users
        .doc(user.uid)
        .set({
          'uid': user.uid,
          'email': user.email,
          'username': user.username,
          'fullName': user.fullName,
          'registerDate': user.registerDate,
          'lastChangedDate': user.lastChangedDate,
          'location': user.location,
          'image': user.image,
          'online': user.online,
          'lastLogInDate': user.lastLogInDate,
          'lastSignOutDate': user.lastSignOutDate,
        })
        .then((value) => Utils.MSG_Debug("User $id Added"))
        .catchError((error) => Utils.MSG_Debug("Failed to add user: $error"));
  }

  Future<UserModel?> getUserData(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        return UserModel(
          uid: userDoc['uid'],
          email: userDoc['email'],
          username: userDoc['username'],
          fullName: userDoc['fullName'],
          registerDate: userDoc['registerDate'],
          lastChangedDate: userDoc['lastChangedDate'],
          location: userDoc['location'],
          image: userDoc['image'],
          online: userDoc['online'],
          lastLogInDate: userDoc['lastLogInDate'],
          lastSignOutDate: userDoc['lastSignOutDate'],
        );
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
        return null;
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user data: $error");
      return null;
    }
  }

  Future<String> getUserAttribute(String uid, String attribute) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        String attributeFinal = userDoc[attribute];
        //Utils.MSG_Debug("########################### $attributeFinal");
        return attributeFinal;
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
        return "??";
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user data: $error");
      return "??";
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String currTime = Utils.currentTimeUser();

      users
          .doc(user.uid)
          .update({
            'uid': user.uid,
            'email': user.email,
            'username': user.username,
            'fullName': user.fullName,
            'registerDate': user.registerDate,
            'lastChangedDate': currTime,
            'location': user.location,
            'image': user.image,
            'online': user.online,
            'lastLogInDate': user.lastLogInDate,
            'lastSignOutDate': user.lastSignOutDate,
          })
          .then((value) => Utils.MSG_Debug("User $user.uid Updated"))
          .catchError(
              (error) => Utils.MSG_Debug("Failed to update user: $error"));
    } catch (error) {
      Utils.MSG_Debug("Error updating user data: $error");
    }
  }

  Future<void> updateUserOnline(UserModel user, bool type) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String currTime = Utils.currentTimeUser();

      if (type) {
        users
            .doc(user.uid)
            .update({
              'uid': user.uid,
              'email': user.email,
              'username': user.username,
              'fullName': user.fullName,
              'registerDate': user.registerDate,
              'lastChangedDate': currTime,
              'location': user.location,
              'image': user.image,
              'online': "1",
              'lastLogInDate': user.lastLogInDate,
              'lastSignOutDate': user.lastSignOutDate,
            })
            .then((value) => Utils.MSG_Debug("User ${user.uid} Updated"))
            .catchError(
                (error) => Utils.MSG_Debug("Failed to update user: $error"));
      } else {
        users
            .doc(user.uid)
            .update({
              'uid': user.uid,
              'email': user.email,
              'username': user.username,
              'fullName': user.fullName,
              'registerDate': user.registerDate,
              'lastChangedDate': currTime,
              'location': user.location,
              'image': user.image,
              'online': "0",
              'lastLogInDate': user.lastLogInDate,
              'lastSignOutDate': user.lastSignOutDate,
            })
            .then((value) => Utils.MSG_Debug("User ${user.uid} Updated"))
            .catchError(
                (error) => Utils.MSG_Debug("Failed to update user: $error"));
      }
    } catch (error) {
      Utils.MSG_Debug("Error updating user data: $error");
    }
  }

  Future<bool> isUserOnline(UserModel user) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userDoc = await users.doc(user.uid).get();

      if (userDoc.exists) {
        return userDoc['online'] == "1";
      } else {
        Utils.MSG_Debug("User with UID ${user.uid} not found");
        return false; // Assuming offline if user not found
      }
    } catch (error) {
      Utils.MSG_Debug("Error checking user online status: $error");
      return false; // Assume offline in case of an error
    }
  }

  Future<List<ReviewModel>> getUserReviews(String uid) async {
    List<ReviewModel> reviews = [];
    try {

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('reviews')
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        var data = doc.data();
        ReviewModel review = ReviewModel(
          uid: data['uid'],
          rid: data['rid'],
          date: data['date'],
          rating: data['rating'],
          comment: data['comment']
        );
        reviews.add(review);
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user reviews: $error");
      return [];
    }

    return reviews;
  }
  
  Future<void> saveReview(ReviewModel data) async{
    try{
      await _firestore.collection('users').doc(data.uid).collection('reviews').doc(data.rid)
          .set({
            'uid': data.uid,
            'rid': data.rid,
            'rating': data.rating,
            'date': data.date,
            'comment': data.comment
          });
    }catch (error) {
      Utils.MSG_Debug("Error saving user review: $error");
    }
  }
}
