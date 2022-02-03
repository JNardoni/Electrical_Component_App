part of 'main.dart';

class Houses {

  String house = "";


  Houses({required this.house,});

  Houses.fromMap(Map<String, dynamic> res)
      : house = res["house"];

  Map<String, Object?> toMap() {
    return {'house' : house};
  }
}