part of 'main.dart';

/*--------------------GLOBALS CLASS-------------------------

Stores two variables - The global name and whether its a basic component or not

 Created when new globals are added to the database, as well as when globals are
 being gathered from the database in addComponent.dart

 */


class Globals {

  String name = "";
  int isBasic = 0;

  Globals({required this.name});

  //Converts an object from SQL map to class for display
  Globals.fromMap(Map<String, dynamic> res)
      : name = res["name"],
        isBasic = res["isBasic"];

  //Creates a map of the class objects for uploading to the SQL database
  Map<String, Object?> toMap() {
    return {'name' : name, "isBasic" : isBasic};
  }
}