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
          'fullname': user.fullname,
          'register_date' : currTime,
          'last_changed_date' : currTime,
          //'password': user.password,
        })
        .then((value) => Utils.MSG_Debug("User $id Added"))
        .catchError((error) => Utils.MSG_Debug("Failed to add user: $error"));
  }

  Future<UserModel?> loadAllUserData(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String currTime = Utils.currentTime();
    Utils.MSG_Debug(currTime);

    try {
      DocumentSnapshot userSnapshot = await users.doc(uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        return UserModel(
          uid: userData['uid'],
          email: userData['email'],
          username: userData['username'],
          fullname: userData['fullname'],
         /* register_date : userData['register_date'],
          last_changed_date : userData['last_changed_date'],*/

          //  password: userData['password'],
        );
      } else {
        return null; // User with the specified UID not found
      }
    } catch (e) {
      Utils.MSG_Debug("Error loading user data: $e");
      return null;
    }
  }
}
