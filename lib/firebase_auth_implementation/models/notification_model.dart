class NotificationModel {
  final String pid;
  final String fromUid;
  //final String fromName;
 // final String fromUsername;
  final int type;
  final int seen;
  final String toUid;
  final String date;

  NotificationModel({
    required this.pid,
    required this.fromUid,
   // required this.fromName,
   // required this.fromUsername,
    required this.type,
    required this.seen,
    required this.toUid,
    required this.date,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'fromUid': fromUid,
      //'fromName': fromName,
      //'fromUsername': fromUsername,
      'type': type,
      'seen': seen,
      'toUid': toUid,
      'date': date,
    };
  }

  // JSON deserialization
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      pid: json['pid'],
      fromUid: json['fromUid'],
      //fromName: json['fromName'],
      //fromUsername: json['fromUsername'],
      type: json['type'],
      seen: json['seen'],
      toUid: json['toUid'],
      date: json['date'],
    );
  }
}
