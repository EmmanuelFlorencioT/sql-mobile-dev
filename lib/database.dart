import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DataBaseHelper {
  static const _databaseName = "myDataBase.db";
  static const _version = 1;

  // Name of the DB Table
  static const table = "my_table";
  // Name of the Table attributes
  static const id = "_id";
  static const name = "_name";
  static const age = "_age";

  // Create the instance of the Database
  late Database
      _db; //late allows to define a variable and initialize the value in null

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    _db = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY,
        $name TEXT NOT NULL,
        $age INTEGER NOT NULL
      );
      INSERT INTO $table($name, $age) VALUES('Test', 23);
    ''');
  }

  void insert(String inputName, int inputAge) async {
    _db.transaction((txn) async {
      int insertId = await txn.rawInsert(
          '''INSERT INTO $table($name, $age) VALUES(?, ?)''',
          [inputName, inputAge]);
      print('''Inserted: $insertId''');
    });
  }

  //Perform a select
  Future<List<Map>> fecth() async {
    List<Map> list = await _db.rawQuery('''SELECT * FROM $table''');
    return list;
  }

  void update(int inputId, String inputName, int inputAge) async {
    int res = await _db.rawUpdate(
        '''UPDATE $table SET $name = ?, $age = ? WHERE $id = ?''',
        [inputName, inputAge, inputId]);
    print('updated: $res');
  }

  void delete(int inputId) async {
    var count =
        await _db.rawDelete('''DELETE FROM $table WHERE $id = ?''', [inputId]);
    assert(count == 1);
  }
}
