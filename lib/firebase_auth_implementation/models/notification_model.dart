class NotificationModel {
  final String pid;
  final String fromUid;
  final int type;
  final int seen;
  final String toUid;
  final String date;

  NotificationModel({
    required this.pid,
    required this.fromUid,
    required this.type,
    required this.seen,
    required this.toUid,
    required this.date,
  });
}
