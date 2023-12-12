class UserModel {
  final String uid;
  final String username;
  final String email;
  final String fullName;
  final String registerDate;
  final String lastChangedDate;
  final String location;
  final String image;
  final String online;
  final String lastLogInDate;
  final String lastSignOutDate;
  /*final String register_date;
  final String last_changed_date;
  final String phoneNo;
  final String password;*/

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.fullName,
    required this.registerDate,
    required this.location,
    required this.image,
    required this.online,
    required this.lastChangedDate,
    required this.lastLogInDate,
    required this.lastSignOutDate,
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
