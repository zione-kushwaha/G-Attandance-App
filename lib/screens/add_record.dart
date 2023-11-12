// ignore_for_file: constant_identifier_names, camel_case_types
import 'dart:async';
import 'package:flutter/material.dart';
import '/providers/studentModel.dart';
import '/widgets/add_record_widget.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class add_record extends StatelessWidget {
  add_record({Key? key}) : super(key: key);
  static const RouteName = '/add_record';
  final TextEditingController startRollController = TextEditingController();
  final TextEditingController endRollController = TextEditingController();

  Future<void> _showBulkAddDialog(
    BuildContext context,
    String date,
    int classId,
  ) async {
    final providerdata =
        Provider.of<studentMOdelProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Starting and Ending Roll Number'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: startRollController,
                decoration: const InputDecoration(
                  labelText: 'Starting Roll',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: endRollController,
                decoration: const InputDecoration(
                  labelText: 'Ending Roll',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final startRollText = startRollController.text;
                final endRollText = endRollController.text;

                if (startRollText.isEmpty || endRollText.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,
                    title: 'Alert !!!',
                    titleTextStyle: const TextStyle(color: Colors.red),
                    desc: 'Both starting and ending roll are Compulsory',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  int? startRoll = int.tryParse(startRollText);
                  int? endRoll = int.tryParse(endRollText);

                  if (startRoll != null && endRoll != null) {
                    if (startRoll > endRoll) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'No Record Added',
                        desc:
                            'Starting Rollno should be less than the ending Rollno...',
                        btnOkOnPress: () {},
                      ).show();
                      return; // Exit the function if the starting roll is greater than the ending roll.
                    } else {
                      providerdata.insertStudentsInBulk(
                        classId,
                        startRoll,
                        endRoll,
                      );
                    }
                  }

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
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

  @override
  Widget build(BuildContext context) {
    final providerdata =
        Provider.of<studentMOdelProvider>(context, listen: false);
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String className = arguments['class_name'];
    final String date = arguments['date'];
    final int classId = arguments['class_id'];
    final TextEditingController rollNoController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        title: Text('Add Record of $className'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: rollNoController,
              decoration: const InputDecoration(
                labelText: 'Enter the Roll No',
                prefixIcon: Icon(Icons.format_list_numbered_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Enter the name',
                prefixIcon: Icon(Icons.person_2_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (rollNoController.text.isEmpty) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,
                    title: 'Alert !!!',
                    titleTextStyle: const TextStyle(color: Colors.red),
                    desc: 'Roll No is compulsory to enter',
                    btnOkOnPress: () {},
                  ).show();
                } else {
                  providerdata.InsertStudentsModel(
                      student_model(
                          name: nameController.text.toString(),
                          rollno: int.parse(rollNoController.text),
                          uniquekey: classId),
                      context);
                  rollNoController.clear();
                  nameController.clear();
                }
              },
              child: const Text('Add'),
            ),
            Expanded(
              child: AddRecordWidget(
                class_name: className,
                class_id: classId,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton.extended(
          onPressed: () {
            _showBulkAddDialog(
              context,
              date,
              classId,
            );
          },
          label: const Text('Add Bulk Records'),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
