part of 'main.dart';

class Globals {

  String name = "";
  int isBasic = 0;

  Globals({required this.name});

  Globals.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        isBasic = res["isBasic"];

  Map<String, Object?> toMap() {
    return {'name' : name, "isBasic" : isBasic};
  }
}