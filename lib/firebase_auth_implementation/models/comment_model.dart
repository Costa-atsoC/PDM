class CommentModel {
  final String id; // Comment id
  final String pid; // Post id
  final String uid; // User id
  final String cid; // Commenter id
  final String date;
  final String comment;

  const CommentModel({
    required this.id,
    required this.pid,
    required this.uid,
    required this.cid,
    required this.date,
    required this.comment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      pid: json['pid'],
      uid: json['uid'],
      cid: json['cid'],
      date: json['date'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pid': pid,
      'uid': uid,
      'cid': cid,
      'date': date,
      'comment': comment,
    };
  }
}
