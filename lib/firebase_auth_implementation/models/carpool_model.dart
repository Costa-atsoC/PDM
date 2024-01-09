class CarpoolModel {
  final String id;
  final String req_id;
  final String pid;
  final String from_uid;
  final String date;

  const CarpoolModel({
    required this.id,
    required this.req_id,
    required this.pid,
    required this.from_uid,
    required this.date,
  });

  factory CarpoolModel.fromJson(Map<String, dynamic> json) {
    return CarpoolModel(
      id: json['id'],
      req_id: json['req_id'],
      pid: json['pid'],
      from_uid: json['from_uid'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'req_id': req_id,
      'pid': pid,
      'from_uid': from_uid,
      'date': date,
    };
  }
}
