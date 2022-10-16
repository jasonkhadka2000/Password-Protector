import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UserHelper {
  final String _dbname = "user_details.db";
  final String _tablename = "userdetails";
  final int version = 1;

  static final String columnid = "_id";
  static final String columnusername = "username";
  static final String columnpassword = "password";
  static final String columnemail = "email";

  static final instance = UserHelper._init();
  static Database? _database;

  UserHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initiateDatabase();
    return _database!;
  }

  Future<Database> initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbname);

    return await openDatabase(path, version: version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int v) async {
    await db.execute('''
      CREATE TABLE $_tablename(

      $columnusername TEXT NOT NULL,   
      $columnemail TEXT NOT NULL,
      $columnpassword TEXT NOT NULL
     
      )
      
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return db.insert(_tablename, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tablename);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnid];
    return db.update(_tablename, row, where: '$columnid=?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(_tablename, where: '$columnid=?', whereArgs: [id]);
  }
}
