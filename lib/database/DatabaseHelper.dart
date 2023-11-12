// ignore_for_file: file_names

import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "user_db";
  static const _databaseVersion = 2;
  //creating the private constructor
  DatabaseHelper._privateconstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateconstructor();

  static Database? _database;
  //creating the getter to get the database
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDb();
      return _database;
    }
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: oncreate);
  }

  Future oncreate(Database db, int version) async {
    //creation of the total_table in the database
    await db.execute('''CREATE TABLE total_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    rollno INTEGER NOT NULL,
    ispresent INTEGER NOT NULL,
    date TEXT NOT NULL,
    uniquekey INTEGER NOT NULL,
    class_name TEXT NOT NULL,
    FOREIGN KEY (uniquekey) REFERENCES class_table(id)
  )''');

    // creation of the student_table in the database
    await db.execute('''CREATE TABLE student_table (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   name TEXT,
   rollno INTEGER NOT NULL,
   uniquekey INTEGER NOT NULL,
   FOREIGN KEY (uniquekey) REFERENCES class_table(id)
   )''');

    // creation of the class_table in the database
    await db.execute('''CREATE TABLE class_table (
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   class_name TEXT NOT NULL,
   class_id TEXT NOT NULL
   )''');
  }
}
