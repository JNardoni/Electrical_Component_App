part of 'main.dart';

/*--------------------HOUSE CLASS-------------------------

Stores two variables - The house name and the time at which it was created

 Created when new houses are added to the database, as well as when houses are
 being gathered from the database

 */
class Houses {

  String house = "";
  int createdDate = DateTime.now().millisecondsSinceEpoch; //Sets the time on creation

  Houses({required this.house}); //adds the name of the house

  //Converts an object from SQL map to class for display
  Houses.fromMap(Map<String, dynamic> res)
      : house = res["house"],
        createdDate = res['createdDate'];

  //Creates a map of the class objects for uploading to the SQL database
  Map<String, Object?> toMap() {
    return {'house' : house, 'createdDate': createdDate};
  }
}