part of 'main.dart';

class Comps {

  String house = "";
  String room = "";
  String comp = "";
  int count = 0;
  int isBasic = 0;
  String desc = "";

  Comps({required this.house, required this.room, required this.comp, required this.isBasic});

  Comps.fromMap(Map<String, dynamic> res)
      : house = res["house"],
        room = res["room"],
        comp = res["comp"],
        count = res["count"],
        isBasic = res["isBasic"],
        desc = res["desc"];

  Map<String, Object?> toMap() {
    return {'house' : house, 'room' : room, 'comp' : comp, 'count' : count, 'isBasic' : isBasic, 'desc' : desc};
  }


  Comps.roomsfromMap(Map<String, dynamic> res)
      : room = res["room"];

  Map<String, Object?> roomstoMap() {
    return {'room' : room};
  }


}