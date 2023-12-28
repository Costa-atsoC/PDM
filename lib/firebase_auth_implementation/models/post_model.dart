import 'dart:convert';

class PostModel {
  final String uid;
  final String userFullName;
  final String username;
  final String pid;
  final String likes;
  final String title;
  final String description;
  final String date;  // Change type to DateTime
  final String totalSeats;
  final String freeSeats;
  final String location;
  final String startLocation;
  final String endLocation;
  final String registerDate;
  final String lastChangedDate;

  const PostModel({
    required this.uid,
    required this.userFullName,
    required this.username,
    required this.pid,
    required this.likes,
    required this.title,
    required this.description,
    required this.date,
    required this.totalSeats,
    required this.freeSeats,
    required this.location,
    required this.startLocation,
    required this.endLocation,
    required this.registerDate,
    required this.lastChangedDate,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userFullName': userFullName,
      'username': username,
      'pid': pid,
      'likes': likes,
      'title': title,
      'description': description,
      'date': date,
      'totalSeats': totalSeats,
      'freeSeats': freeSeats,
      'location': location,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'registerDate': registerDate,
      'lastChangedDate': lastChangedDate,
    };
  }

  // JSON deserialization
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json['uid'],
      userFullName: json['userFullName'],
      username: json['username'],
      pid: json['pid'],
      likes: json['likes'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      totalSeats: json['totalSeats'],
      freeSeats: json['freeSeats'],
      location: json['location'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      registerDate: json['registerDate'],
      lastChangedDate: json['lastChangedDate'],
    );
  }
}