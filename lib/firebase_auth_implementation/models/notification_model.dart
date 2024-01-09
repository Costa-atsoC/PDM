class NotificationModel {
  final String nid;
  final String pid;
  final String fromUid;
  final String descp;
  final int type;
  final int seen;
  final String toUid;
  final String date;

  NotificationModel({
    required this.nid,
    required this.pid,
    required this.fromUid,
    required this.descp,
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
      'nid': nid,
      'pid': pid,
      'fromUid': fromUid,
      'type': type,
      'seen': seen,
      'toUid': toUid,
      'date': date,
      'descp': descp,
    };
  }

  // JSON deserialization
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      nid: json['nid'],
      pid: json['pid'],
      fromUid: json['fromUid'],
      descp: json['descp'],
      type: json['type'],
      seen: json['seen'],
      toUid: json['toUid'],
      date: json['date'],
    );
  }
}
