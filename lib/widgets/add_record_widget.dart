// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import '/providers/studentModel.dart';
import '/widgets/PopupMenuButtonWithDialog.dart';
import 'package:provider/provider.dart';

class AddRecordWidget extends StatelessWidget {
  final String class_name;
  final int class_id;
  const AddRecordWidget({
    super.key,
    required this.class_name,
    required this.class_id,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<student_model>>(
      future: Provider.of<studentMOdelProvider>(context)
          .getStudentsByClassId(class_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No records available'));
        } else {
          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(records[index].rollno.toString()),
                  ),
                  title: Center(child: Text(records[index].name.toString())),
                  trailing: PopupMenuButtonWithDialog(
                    rollno: records[index].rollno.toString(),
                    name: records[index].name,
                    class_id: class_id,
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
