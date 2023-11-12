// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import '/providers/studentModel.dart';
import 'package:provider/provider.dart';
import '../providers/total_record.dart';

class student_report_screen_widget extends StatelessWidget {
  final int class_id;
  const student_report_screen_widget({super.key, required this.class_id});

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<totalRecordProvider>(context);
    final studentProvider = Provider.of<studentMOdelProvider>(context);

    return FutureBuilder(
      future: studentProvider.getStudentsByClassId(class_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No student records available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${student.rollno}'),
                  ),
                  title: Center(
                    child: Text('${student.name}'),
                  ),
                  trailing: FutureBuilder<int>(
                    future:
                        providerData.countDaysPresent(class_id, student.rollno),
                    builder: (context, daysPresentSnapshot) {
                      if (daysPresentSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (daysPresentSnapshot.hasError) {
                        return Text('Error: ${daysPresentSnapshot.error}');
                      } else {
                        return Text('${daysPresentSnapshot.data}');
                      }
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
