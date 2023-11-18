import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_auth_implementation/models/user_model.dart';

class UserFirestore {
  Future<void> saveUserData(UserModel user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    users
        .doc(user.uid)
        .set({
          'uid': user.uid,
          'email': user.email,
          'username': user.username,
          'fullname': user.fullname,
          //'password': user.password,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<UserModel?> loadAllUserData(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

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
          //  password: userData['password'],
        );
      } else {
        return null; // User with the specified UID not found
      }
    } catch (e) {
      print("Error loading user data: $e");
      return null;
    }
  }
}
