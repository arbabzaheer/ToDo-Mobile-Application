import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import '../models/todo.dart';
class DBHelper {
  static final _databaseName = "todo_database.db";
  static final _databaseVersion = 1;
  static final table = 'tasks';

  static final ColumnId = 'id';
  static final ColumnTitle = 'title';

//Singleton pattern/instance
  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();
  
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  _initDatabase() async{
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }  
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $ColumnId INTEGER PRIMARY KEY,
        $ColumnTitle TEXT NOT NULL
      )
    ''');
  }
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }
Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$ColumnId = ?', whereArgs: [id]);
  }
}
