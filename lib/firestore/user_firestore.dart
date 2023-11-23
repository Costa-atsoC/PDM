import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../Utils.dart';

class UserFirestore {
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
          'registerDate' : user.registerDate,
          'lastChangedDate' : user.lastChangedDate,
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
          lastChangedDate: userDoc['lastChangedDate']
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
        Utils.MSG_Debug("########################### $attributeFinal");
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
}
