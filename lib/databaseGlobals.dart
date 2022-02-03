/*

part of 'main.dart';

class DatabaseGlobals {

  static final DatabaseGlobals _databaseGlobals = DatabaseGlobals._();

  DatabaseGlobals._();

  late Database globalsdb;

  factory DatabaseGlobals() {
    return _databaseGlobals;
  }

  // ...
  Future<void> initGlobalsDB() async {
    String path = await getDatabasesPath();
    globalsdb = await openDatabase(
      Path.join(path, 'globals.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE global_variables (
              name TEXT NOT NULL,
              isBasic INTEGER NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }

  Future<int> insertGlobals(Globals globals) async {
    int result = await globalsdb.insert('global_variables', globals.toMap());
    return result;
  }

  Future<int> updateGlobals(Houses house) async {
    int result = await globalsdb.update(
      'global_variables',
      house.toMap(),
      where: "house = ?",
      whereArgs: [house.house],
    );
    return result;
  }

  Future<List<Globals>> retrieveGlobals() async {
    final List<Map<String, Object?>> queryResult = await globalsdb.query('global_variables');
    return queryResult.map((e) => Globals.fromMap(e)).toList();
  }

  Future<void> deleteGlobals(String name) async {
    await globalsdb.delete(
      'global_variables',
      where: "name = ?",
      whereArgs: [name],
    );
  }

}*/