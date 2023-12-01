// ignore_for_file: camel_case_types, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import '/database/DatabaseHelper.dart';

//creating the student model
class student_model {
  int? id;
  String? name;
  int rollno;
  int uniquekey;
  student_model(
      {this.id, this.name = '', required this.rollno, required this.uniquekey});
//converting the object back to the map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rollno': rollno,
        'uniquekey': uniquekey,
      };
  //converting the map back to object
  factory student_model.fromMap(Map<String, dynamic> json) => student_model(
        id: json['id'],
        name: json['name'] as String?,
        rollno: json['rollno'],
        uniquekey: json['uniquekey'],
      );
}

//creating the provider for this student model
class studentMOdelProvider with ChangeNotifier {
  final dbProvider = DatabaseHelper.instance;

  Future<List<student_model>> getStudentsByClassId(int id) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> allRows = await db!.query('student_table',
        where: 'uniquekey = ?', whereArgs: [id], orderBy: 'rollno ASC');
    List<student_model> students =
        allRows.map((contact) => student_model.fromMap(contact)).toList();
    return students;
  }

  // Function to check if a student with the given rollno exists for a specific class
  Future<bool> doesStudentExist(int uniquekey, int rollno) async {
    final existingStudents = await getStudentsByClassId(uniquekey);
    return existingStudents.any((s) => s.rollno == rollno);
  }

  Future<int?> InsertStudentsModel(
      student_model student, BuildContext context) async {
    final db = await dbProvider.database;

    // Check if the student with the given rollno already exists
    if (await doesStudentExist(student.uniquekey, student.rollno)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Alert!!!",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
                "This rollno. is already present. Choose other one..."),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return null;
    }

    // Insert the new student directly into the database.
    final int insertResult =
        await db!.insert('student_table', student.toJson());

    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.lightBlue,
        content: Text('Student Added Successfully!!!'),
        duration: Duration(seconds: 1),
      ),
    );

    return insertResult;
  }

//function to delete classModel record from the table
  Future<int?> DeleteClassModel(int Id) async {
    final db = await dbProvider.database;
    var result = await db?.delete(
      'student_table',
      where: 'uniquekey= ?',
      whereArgs: [Id],
    );
    notifyListeners();
    return result;
  }

  Future<void> insertStudentsInBulk(
      int classId, int startingRollNo, int endingRollNo) async {
    final db = await dbProvider.database;
    final batch = db!.batch();

    for (int rollNo = startingRollNo; rollNo <= endingRollNo; rollNo++) {
      // Check if the student with this rollno already exists
      if (await doesStudentExist(classId, rollNo)) {
        continue; // Skip this roll number and move to the next one.
      }

      final student = student_model(rollno: rollNo, uniquekey: classId);
      batch.insert('student_table', student.toJson());
    }

    await batch.commit();
    notifyListeners();
  }

  // Function to delete a student record for a specific class (uniquekey) and rollno
  Future<int?> deleteStudentRecord(int uniquekey, int rollno) async {
    final db = await dbProvider.database;
    final int? result = await db?.delete(
      'student_table',
      where: 'uniquekey = ? AND rollno = ?',
      whereArgs: [uniquekey, rollno],
    );
    notifyListeners();
    return result;
  }

  // Function to rename a student record for a specific class (uniquekey) and rollno
  Future<int?> RenameStudent(int uniquekey, int rollno, String newName) async {
    final db = await dbProvider.database;
    final int? result = await db?.update(
      'student_table',
      {'name': newName},
      where: 'uniquekey = ? AND rollno = ?',
      whereArgs: [uniquekey, rollno],
    );
    notifyListeners();
    return result;
  }

  // Function to get a student by class ID (uniquekey) and roll number
  Future<student_model?> getStudentByRollNo(int uniquekey, int rollno) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> rows = await db!.query('student_table',
        where: 'uniquekey = ? AND rollno = ?', whereArgs: [uniquekey, rollno]);
    if (rows.isNotEmpty) {
      return student_model.fromMap(rows.first);
    }
    return null;
  }
}
