class UserModel {
  final String? uid;
  final String username;
  final String email;
  final String fullName;
  final String registerDate;
  final String lastChangedDate;
  /*final String register_date;
  final String last_changed_date;

   */

  //final String phoneNo;
//  final String password;

  const UserModel({
    this.uid,
    required this.email,
    required this.username,
    required this.fullName,
    required this.registerDate,
    required this.lastChangedDate,
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
