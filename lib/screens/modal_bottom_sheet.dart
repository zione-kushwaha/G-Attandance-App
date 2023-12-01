// ignore_for_file: must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import '/providers/class_modal.dart';
import 'package:provider/provider.dart';

class ModelBottomSheet extends StatelessWidget {
  TextEditingController classIdController = TextEditingController();
  TextEditingController classNameController = TextEditingController();

  ModelBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ProviderData = Provider.of<ClassModelProvider>(context);
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xff757575),
        child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 10,
              right: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 20, // Add padding to move title up
                  left: 20,
                  right: 20,
                ),
                child: const Text(
                  'Add Class',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: classIdController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Class ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: classNameController,
                decoration: InputDecoration(
                  labelText: 'Class Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String classId = classIdController.text;
                  String className = classNameController.text;

                  if (classId.isEmpty || className.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Alert !!!',
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text(
                              'Both Class ID and Class Name are required.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    await ProviderData.insertClassModel(
                        ClassModel(
                          class_id: classId,
                          class_name: className,
                        ),
                        context);

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
