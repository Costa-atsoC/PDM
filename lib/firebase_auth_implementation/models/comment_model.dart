class commentModel{
  final String id; //Comment id
  final String pid; //Post id
  final String uid; //User id
  final String cid; //Commenter id
  final String date;
  final String comment;

  const commentModel({
    required this.id,
    required this.pid,
    required this.uid,
    required this.cid,
    required this.date,
    required this.comment
  });
}