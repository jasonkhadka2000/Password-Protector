import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ProtectHelper {
  final String _dbname = "password_details.db";
  final String _tablename = "protect";
  final int version = 1;

  static final String columnid = "_id";
  static final String columnaccountof = "account";
  static final String columnpassword = "password";
  static final String columnusername = "username";

  static final ProtectHelper instance = ProtectHelper._init();
  static Database? _database;

  ProtectHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initiateDatabase();
    return _database!;
  }

  Future<Database> initiateDatabase() async {
    print("inside initiate database");
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbname);

    return await openDatabase(path, version: version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int v) async {
    print("New Table created");
    await db.execute('''
      CREATE TABLE $_tablename(
      
      $columnid integer auto increment PRIMARY KEY,
      $columnaccountof TEXT NOT NULL,
      $columnusername TEXT NOT NULL,
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

    return db.query(_tablename);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnid];
    return db.update(_tablename, row, where: '$columnid=?', whereArgs: [id]);
  }

  Future<int> delete(String id, String id1, String id2) async {
    Database db = await instance.database;
    return db.delete(_tablename,
        where: '$columnaccountof=? AND $columnusername=? AND $columnpassword=?',
        whereArgs: [id, id1, id2]);
  }
}
