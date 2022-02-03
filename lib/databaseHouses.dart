part of 'main.dart';

class DatabaseHouses {

  static final DatabaseHouses _databaseHouses = DatabaseHouses._();

  DatabaseHouses._();

  late Database worlddb;

  factory DatabaseHouses() {
    return _databaseHouses;
  }

  // ...
  Future<void> initWorldDB() async {
    String path = await getDatabasesPath();
    worlddb = await openDatabase(
      Path.join(path, 'component_mapping.db'),
      onCreate: (database, version) async {
        //Create house list table
        await database.execute(
          """
            CREATE TABLE house_list (
              house TEXT NOT NULL
            )
          """,
        );
        //Create components table
        await database.execute("CREATE TABLE comps_list (house TEXT NOT NULL, room TEXT NOT NULL, comp TEXT NOT NULL, count INTEGER NOT NULL, isBasic INTEGER NOT NULL, desc TEXT NOT NULL)",
        );
        //Create a table with the list of global components
        await database.execute(
          """
            CREATE TABLE global_list (
              name TEXT NOT NULL,
              isBasic INTEGER NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<int> insertHouse(Houses house) async {
    int result = await worlddb.insert('house_list', house.toMap());
    return result;
  }

  //Unused, no edit option
  Future<int> updateHouse(Houses house) async {
    int result = await worlddb.update(
      'house_list',
      house.toMap(),
      where: "house = ?",
      whereArgs: [house.house],
    );
    return result;
  }

  Future<List<Houses>> retrieveHouses() async {
    final List<Map<String, Object?>> queryResult = await worlddb.query('house_list');
    return queryResult.map((e) => Houses.fromMap(e)).toList();
  }

  Future<void> deleteHouse(String name) async {
    await worlddb.delete(
      'house_list',
      where: "house = ?",
      whereArgs: [name],
    );
  }

  //CRUD GLOBALS
  //Table name for globals : global_list

  Future<int> insertGlobals(Globals globals) async {
    int result = await worlddb.insert('global_list', globals.toMap());
    return result;
  }

  Future<List<Globals>> retrieveGlobals() async {
    final List<Map<String, Object?>> queryResult = await worlddb.query('global_list');
    return queryResult.map((e) => Globals.fromMap(e)).toList();
  }

  //CRUD ROOMS


  //TODO filter to one of each room test?
  Future<List<Comps>> retrieveRooms() async {
    final List<Map<String, Object?>> queryResult = await worlddb.rawQuery("SELECT DISTINCT room FROM comps_list WHERE house = ?", [houseName]);
  //  final List<Map<String, Object?>> queryResult = await worlddb.rawQuery("SELECT DISTINCT room FROM comps_list WHERE house = ?", [houseName]);
    //final List<Map<String, Object?>> queryResult = await worlddb.rawQuery("SELECT * FROM comps_list WHERE house = ?", [houseName]);
    //return queryResult.map((e) => Comps.fromMap(e)).toList();


    return queryResult.map((e) => Comps.roomsfromMap(e)).toList();
  }

  //CRUD COMPS
  //Table name for comps: comps_list

  Future<int> insertComp(Comps comp) async {
    int result = await worlddb.insert("comps_list", comp.toMap());
    return result;
  }

  Future<List<Comps>> retrieveAdvComps(String roomName) async {
    final List<Map<String, Object?>> queryResult = await worlddb.query("comps_list", where: 'house = ? AND room = ? AND isBasic = ?', whereArgs: [houseName, roomName, 0]);
    return queryResult.map((e) => Comps.fromMap(e)).toList();
  }

  Future<List<Comps>> retrieveBasicComps(String roomName) async {
    final List<Map<String, Object?>> queryResult = await worlddb.query("comps_list", where: 'house = ? AND room = ? AND isBasic = ?', whereArgs: [houseName, roomName, 1]);
    return queryResult.map((e) => Comps.fromMap(e)).toList();
  }
  Future<int> updateComps(Comps comp) async {
    int result = await worlddb.update(
      "comps_list",
      comp.toMap(),
      where: "house = ? AND room = ? AND comp = ?",
      whereArgs: [comp.house, comp.room, comp.comp],
    );
    return result;
  }

  //Deletes an entire room, removing all associated comps
  Future<void> deleteComps_Room(String roomName) async {
    await worlddb.delete(
      "comps_list",
      where: "room = ?",
      whereArgs: [roomName],
    );
  }

  //Deletes an entire house, removing all associated comps
  Future<void> deleteComps_House(String roomName) async {
    await worlddb.delete(
      "comps_list",
      where: "room = ?",
      whereArgs: [roomName],
    );
  }


}