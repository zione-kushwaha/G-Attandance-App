// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../database/DatabaseHelper.dart';

//creating the class model

class ClassModel {
  final int? id;
  final String class_name;
  final String class_id;
  ClassModel({this.id, required this.class_name, required this.class_id});
  //converting the object to map
  Map<String, dynamic> toMap() => {
        'id': id,
        'class_name': class_name,
        'class_id': class_id,
      };
  //converting the map back to object
  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
        id: map['id'],
        class_name: map['class_name'],
        class_id: map['class_id']);
  }
}

class ClassModelProvider with ChangeNotifier {
  final databasehelper = DatabaseHelper.instance;

  Future<List<ClassModel>> getClassModels() async {
    final db = await databasehelper.database;
    List<Map<String, dynamic>> allRows = await db!.query('class_table');
    List<ClassModel> classes =
        allRows.map((e) => ClassModel.fromMap(e)).toList();
    return classes;
  }

//function to insert the record in the database helper table
  Future<int?> insertClassModel(ClassModel classs, BuildContext context) async {
    final db = await databasehelper.database;
    var result = db!.insert('class_table', classs.toMap());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.lightBlue,
        content: Text('Class Added successfully!!!'),
        duration: Duration(seconds: 1),
      ),
    );
    notifyListeners();
    return result;
  }

//function to delete record from the database
  Future<int?> deleteClassModel(int id) async {
    final db = await databasehelper.database;
    int? res =
        await db?.delete('class_table', where: 'id = ?', whereArgs: [id]);
    notifyListeners();
    return res;
  }

  Future<int?> updateClassModel(
      ClassModel oldClass, ClassModel newClass, BuildContext context) async {
    final db = await databasehelper.database; // Await the Future<Database>
    final int? updateResult = await db?.update(
      'class_table',
      {
        'class_id': newClass.class_id,
        'class_name': newClass.class_name,
      },
      where: 'id = ?',
      whereArgs: [oldClass.id],
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.lightBlue,
        content: Text('Class Modified successfully!!!'),
        duration: Duration(seconds: 1),
      ),
    );
    notifyListeners();
    return updateResult;
  }

  // Future<bool> isClassIdConflict(String classId) async {
  //   final db = await databasehelper.database; // Await the Future<Database>
  //   final List<Map<String, dynamic>>? result = await db?.query(
  //     'class_table',
  //     where: 'class_id = ?',
  //     whereArgs: [classId],
  //   );

  //   return result != null && result.isNotEmpty;
  // }

  // Function to get class name by class ID
  Future<String?> getClassNameById(int id) async {
    final db = await databasehelper.database; // Await the Future<Database>

    // Query the database to get the class name by class ID
    final List<Map<String, dynamic>>? result = await db?.query(
      'class_table',
      columns: ['class_name'],
      where: 'id = ?',
      whereArgs: [id],
    );
    // If a result is found, return the class name, otherwise return null
    if (result != null && result.isNotEmpty) {
      return result[0]['class_name'] as String?;
    } else {
      return null;
    }
  }
}
