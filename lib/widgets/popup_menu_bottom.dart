// ignore_for_file: use_build_context_synchronously, camel_case_types
import 'package:flutter/material.dart';
import '/providers/class_modal.dart';
import '/providers/studentModel.dart';
import '/providers/total_record.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class popup_menu_bottom extends StatelessWidget {
  final ClassModel xyz;

  const popup_menu_bottom({super.key, required this.xyz});

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ClassModelProvider>(context);
    final studentProvider = Provider.of<studentMOdelProvider>(context);
    final totalprovider = Provider.of<totalRecordProvider>(context);
    return PopupMenuButton<int>(
      onSelected: (value) {
        if (value == 1) {
          _showEditDialog(context, providerData, xyz);
        } else if (value == 2) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.question,
            animType: AnimType.rightSlide,
            title: 'Delete',
            desc: 'Are you sure to delete?',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              _deleteClass(context, providerData, xyz);
              studentProvider.deleteClassModel(xyz.id!);
              totalprovider.deleteRecordsByUniqueKey(xyz.id!);
            },
          ).show();
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Edit'),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text('Delete'),
          ),
        ];
      },
    );
  }

  Future<void> _showEditDialog(BuildContext context,
      ClassModelProvider provider, ClassModel classItem) async {
    TextEditingController classNameController =
        TextEditingController(text: classItem.class_name);
    TextEditingController classIdController =
        TextEditingController(text: classItem.class_id);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classNameController,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: classIdController,
                decoration: const InputDecoration(labelText: 'Class ID'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (await provider.isClassIdConflict(classIdController.text)) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Alert !!!',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text(
                              'This class ID is already present. Choose another one...'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                } else {
                  // Update the class name and class ID

                  provider.updateClassModel(
                      xyz,
                      ClassModel(
                        class_id: classIdController.text,
                        class_name: classNameController.text,
                      ),
                      context);
                  Navigator.pop(context);
                }
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

  Future<void> _deleteClass(BuildContext context, ClassModelProvider provider,
      ClassModel classItem) async {
    provider.deleteClassModel(classItem.id!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Class deleted successfully!!!'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
