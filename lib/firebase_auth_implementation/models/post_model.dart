class PostModel {
  final String uid;
  final String pid;
  final String title;
  final String description;
  final String date;
  final String totalSeats;
  final String freeSeats;
  final String location;
  final String startLocation;
  final String endLocation;
  final String registerDate;
  final String lastChangedDate;

  const PostModel({
    required this.uid,
    required this.pid,
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
}
