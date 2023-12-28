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
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'fullName': fullName,
      'registerDate': registerDate,
      'location': location,
      'image': image,
      'online': online,
      'lastChangedDate': lastChangedDate,
      'lastLogInDate': lastLogInDate,
      'lastSignOutDate': lastSignOutDate,
    };
  }

  // JSON deserialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      username: json['username'],
      fullName: json['fullName'],
      registerDate: json['registerDate'],
      location: json['location'],
      image: json['image'],
      online: json['online'],
      lastChangedDate: json['lastChangedDate'],
      lastLogInDate: json['lastLogInDate'],
      lastSignOutDate: json['lastSignOutDate'],
    );
  }
}
