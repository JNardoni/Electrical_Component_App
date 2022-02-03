/*part of 'main.dart';

class DatabaseComps {

  static final DatabaseComps _databaseComps = DatabaseComps._();

  DatabaseComps._();

  late Database compsdb;

  factory DatabaseComps() {
    return _databaseComps;
  }

  // ...
  Future<void> initCompsDB() async {
    String path = await getDatabasesPath();
    compsdb = await openDatabase(
      Path.join(path, houseName+'_comps.db'),
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE " + houseName + "_comps (room TEXT NOT NULL, comp TEXT NOT NULL, count INTEGER NOT NULL, isBasic INTEGER NOT NULL, desc TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }
/*
  Future<int> insertComp(Comps comp) async {
    int result = await compsdb.insert(houseName + "_comps", comp.toMap());
    return result;
  }*/

  Future<int> updateComps(Comps comp) async {
    int result = await compsdb.update(
      houseName + "_comps",
      comp.toMap(),
      where: "room = ? AND comp = ?",
      whereArgs: [comp.room, comp.comp],
    );
    return result;
  }

  Future<List<Comps>> retrieveBasicComps(String roomName) async {
    final List<Map<String, Object?>> queryResult = await compsdb.query(houseName + "_comps", where: 'room = ? AND isBasic = ?', whereArgs: [roomName,1]);
    return queryResult.map((e) => Comps.fromMap(e)).toList();
  }

  Future<List<Comps>> retrieveAdvComps(String roomName) async {
    final List<Map<String, Object?>> queryResult = await compsdb.query(houseName + "_comps", where: 'room = ? AND isBasic = ?', whereArgs: [roomName,0]);
    return queryResult.map((e) => Comps.fromMap(e)).toList();
  }

  //Deletes an entire room, removing all associated comps
  Future<void> deleteComps_EntireRoom(String roomName) async {
    await compsdb.delete(
      houseName + "_comps",
      where: "room = ?",
      whereArgs: [roomName],
    );
  }

  //Deletes a single component from a single room TODO untested, and unused
  Future<void> deleteComps_Single(String roomName, String compName) async {
    await compsdb.delete(
      houseName + "_comps",
      where: "room = ? AND comp = ?",
      whereArgs: [roomName, compName],
    );
  }

  Future<void> deleteCompsTable(String house_name) async {
    await  compsdb.execute("DROP TABLE IF EXISTS " + house_name +"_comps");
  }
}*/