part of 'main.dart';

class Houses {

  String house = "";
  int createdDate = DateTime.now().millisecondsSinceEpoch;


  Houses({required this.house});

  Houses.fromMap(Map<String, dynamic> res)
      : house = res["house"],
        createdDate = res['createdDate'];

  Map<String, Object?> toMap() {
    return {'house' : house, 'createdDate': createdDate};
  }
}