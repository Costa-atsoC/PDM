class ReviewModel{
  final String rid;
  final String uid;
  final String date;
  final num rating;
  final String comment;

  const ReviewModel({
    required this.rid,
    required this.uid,
    required this.date,
    required this.rating,
    required this.comment
  });
}