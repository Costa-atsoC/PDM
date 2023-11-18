class UserModel {
  final String? uid;
  final String username;
  final String email;
  final String fullname;
  //final String phoneNo;
//  final String password;

  const UserModel({
    this.uid,
    required this.email,
   // required this.password,
    required this.username,
    required this.fullname,
    //required this.phoneNo,
});
/*
  toJson(){
    return {
      "FullName" : fullName,
      "Email" : email,
      "Phone" : phoneNo,
      "Password" : password,
    };
  }
 */
}