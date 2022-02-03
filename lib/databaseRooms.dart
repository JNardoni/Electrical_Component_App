/*part of 'main.dart';

class DatabaseRooms {

  static final DatabaseRooms _databaseRooms = DatabaseRooms._();

  DatabaseRooms._();

  late Database roomsdb;

  factory DatabaseRooms() {
    return _databaseRooms;
  }

  // ...
  Future<void> initRoomsDB() async {
    String path = await getDatabasesPath();
    roomsdb = await openDatabase(
      Path.join(path, houseName+'_rooms.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE " + houseName + "_rooms (rooms TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<int> insertRoom(Rooms rooms) async {
    int result = await roomsdb.insert(houseName + "_rooms", rooms.toMap());
    return result;
  }

  Future<int> updateRooms(Rooms rooms) async {
    int result = await roomsdb.update(
      houseName + "_rooms",
      rooms.toMap(),
      where: "rooms = ?",
      whereArgs: [rooms.room],
    );
    return result;
  }

  Future<List<Rooms>> retrieveRooms() async {
    final List<Map<String, Object?>> queryResult = await roomsdb.query(houseName + "_rooms");
    return queryResult.map((e) => Rooms.fromMap(e)).toList();
  }

  //TODO untestested
  Future<void> deleteRoom(String name) async {
    await roomsdb.delete(
      houseName + "_rooms",
      where: "rooms = ?",
      whereArgs: [name],
    );
 /*   await roomsdb.delete(
      name + "_comps",
      where: "rooms = ?",
      whereArgs: [name],
    );*/
  }

  Future<void> deleteRoomsTable(String house_name) async {
    await roomsdb.execute("DROP TABLE IF EXISTS " + house_name +"_rooms");
  }

}*/