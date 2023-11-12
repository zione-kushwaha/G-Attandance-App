//making the class for the total record
// ignore_for_file: camel_case_types
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '/database/DatabaseHelper.dart';

class totalRecord {
  final int? id;
  final String? name;
  final int rollno;
  final int ispresent;
  final String date;
  final int uniquekey;
  final String classname;
  totalRecord(
      {this.id,
      this.name = '',
      required this.rollno,
      required this.ispresent,
      required this.date,
      required this.uniquekey,
      required this.classname});
  //converting the object to the map
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'rollno': rollno,
        'ispresent': ispresent,
        'date': date,
        'uniquekey': uniquekey,
        'class_name': classname
      };
  //converting the map back to the object
  factory totalRecord.fromMap(Map<String, dynamic> map) {
    return totalRecord(
        id: map['id'],
        name: map['name'],
        rollno: map['rollno'],
        ispresent: map['ispresent'],
        date: map['date'],
        uniquekey: map['uniquekey'],
        classname: map['class_name']);
  }
}

class totalRecordProvider with ChangeNotifier {
  final dbProvider = DatabaseHelper.instance;
// Function to insert a list of totalRecord into the total_table
  Future<void> insertRecords(
      List<totalRecord> records, BuildContext context) async {
    final db = await dbProvider.database;

    // Check if any existing records with the same uniquekey and date exist
    final existingRecords = await db!.query(
      'total_table',
      where: 'uniquekey = ? AND date = ?',
      whereArgs: [records[0].uniquekey, records[0].date],
    );

    if (existingRecords.isEmpty) {
      bool inserted = false;
      for (final record in records) {
        await db.insert('total_table', record.toMap());
        inserted = true;
      }

      if (inserted) {
        // Show a success dialog
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Success',
          desc: 'Records inserted successfully.',
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      } else {
        // Show a warning dialog if no insertion occurred
        // ignore: use_build_context_synchronously
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Warning',
          titleTextStyle: const TextStyle(color: Colors.red),
          desc:
              'For this date record has been stored. please go to class report section to modify/delete',
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show();
      }
    } else {
      // Show a warning dialog if no insertion occurred
      // ignore: use_build_context_synchronously
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.rightSlide,
        title: 'Warning',
        titleTextStyle: const TextStyle(color: Colors.red),
        desc:
            'For this date record has been stored. please go to class report section to modify/delete',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    }

    notifyListeners();
  }

  // Function to get the list of totalRecord for a specific class ID (uniquekey) and date
  Future<List<totalRecord>> getRecordsByClassIdAndDate(
      int uniquekey, String date) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'total_table',
      where: 'uniquekey = ? AND date = ?',
      whereArgs: [uniquekey, date],
    );

    return List.generate(maps.length, (index) {
      return totalRecord.fromMap(maps[index]);
    });
  }

  // Function to get a list of different dates for a specific class ID (uniquekey)
  Future<List<String>> getDistinctDatesByClassId(int uniquekey) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'total_table',
      distinct: true, // Get distinct values
      columns: ['date'], // Select the 'date' column
      where: 'uniquekey = ?',
      whereArgs: [uniquekey],
    );

    // Extract distinct dates from the query result
    List<String> distinctDates =
        maps.map((map) => map['date'] as String).toList();

    return distinctDates;
  }

// Function to count the number of days a student is present in a class
  Future<int> countDaysPresent(int uniquekey, int rollno) async {
    int count = 0;

    // Get all records for the given class_id (uniquekey) and rollno
    final records = await getRecordsByClassIdAndRollNo(uniquekey, rollno);

    // Count the days where the student is marked present (ispresent is not 0)
    for (final record in records) {
      if (record.ispresent != 0) {
        count++;
      }
    }

    return count;
  }

  // Function to get the list of totalRecord for a specific class ID (uniquekey) and rollno
  Future<List<totalRecord>> getRecordsByClassIdAndRollNo(
      int uniquekey, int rollno) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'total_table',
      where: 'uniquekey = ? AND rollno = ?',
      whereArgs: [uniquekey, rollno],
    );

    return List.generate(maps.length, (index) {
      return totalRecord.fromMap(maps[index]);
    });
  }

  // Function to delete all records for a specific unique key
  Future<void> deleteRecordsByUniqueKey(int uniquekey) async {
    final db = await dbProvider.database;
    await db!.delete(
      'total_table',
      where: 'uniquekey = ?',
      whereArgs: [uniquekey],
    );
    notifyListeners();
  }

  // Function to count the number of students present on a specific date for a given class ID (uniquekey)
  Future<int> countStudentsPresentByDate(int uniquekey, String date) async {
    final db = await dbProvider.database;

    // Query the database to get the list of ispresent values for the given date and class ID
    final List<Map<String, dynamic>> maps = await db!.query(
      'total_table',
      columns: ['ispresent'],
      where: 'uniquekey = ? AND date = ?',
      whereArgs: [uniquekey, date],
    );

    // Calculate the number of students present (where ispresent is not 0)
    int count = 0;
    for (final map in maps) {
      final isPresent = map['ispresent'] as int;
      if (isPresent != 0) {
        count++;
      }
    }

    return count;
  }

  // Function to delete totalRecord entries for a specific class ID (uniquekey) and date
  Future<void> deleteRecordsByClassIdAndDate(
      int uniquekey, String date, BuildContext context) async {
    final db = await dbProvider.database;
    await db!.delete(
      'total_table',
      where: 'uniquekey = ? AND date = ?',
      whereArgs: [uniquekey, date],
    );
    notifyListeners();
  }

//function to update records
  Future<void> updateRecords(
    List<int> rollnoList,
    List<String> names,
    List<int> isPresentList,
    int uniquekey,
    String date,
  ) async {
    final db = await dbProvider.database;
    for (int i = 0; i < rollnoList.length; i++) {
      try {
        await db!.update(
          'total_table',
          {
            'name': names[i],
            'rollno': rollnoList[i],
            'ispresent': isPresentList[i],
            'date': date,
          },
          where: 'uniquekey = ? AND rollno = ? AND date = ?',
          whereArgs: [uniquekey, rollnoList[i], date],
        );
      } catch (e) {
        print(e);
      }
    }
    notifyListeners();
  }

  // function to get the total_attandence_days
  Future<int> getTotalAttendanceDays(int classId) async {
    final totalDays = await getDistinctDatesByClassId(classId);
    return totalDays.length;
  }

  // Function to get all records from the total_table
  Future<List<totalRecord>> getAllRecords() async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> maps = await db!.query('total_table');

    return List.generate(maps.length, (index) {
      return totalRecord.fromMap(maps[index]);
    });
  }
}
