// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names
import 'package:flutter/material.dart';
import '/providers/studentModel.dart';
import 'package:provider/provider.dart';

class PopupMenuButtonWithDialog extends StatelessWidget {
  final String rollno;
  final String? name;
  final int class_id;

  const PopupMenuButtonWithDialog(
      {super.key, required this.rollno, this.name, required this.class_id});

  @override
  Widget build(BuildContext context) {
    final provider_data =
        Provider.of<studentMOdelProvider>(context, listen: false);

    return PopupMenuButton<int>(
      onSelected: (value) async {
        if (value == 1) {
          final student = await provider_data.getStudentByRollNo(
              class_id, int.parse(rollno));
          if (student != null) {
            _showEditDialog(context, provider_data, rollno, class_id, student);
          }
        } else if (value == 2) {
          final student = await provider_data.getStudentByRollNo(
              class_id, int.parse(rollno));
          if (student != null) {
            provider_data.deleteStudentRecord(class_id, student.rollno);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Record deleted successfully!!!'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 1, // For renaming
            child: Text('Rename'),
          ),
          const PopupMenuItem(
            value: 2, // For deleting
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  Future<void> _showEditDialog(
      BuildContext context,
      studentMOdelProvider providers,
      String rollno,
      int class_id,
      student_model student) async {
    TextEditingController new_name =
        TextEditingController(text: student.name ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: new_name,
                decoration:
                    const InputDecoration(labelText: 'Enter the new name'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await providers.renameStudent(
                    class_id, int.parse(rollno), new_name.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Rename successful!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
