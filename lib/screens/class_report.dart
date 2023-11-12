// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '/providers/total_record.dart';
import '/screens/individual_report_screen.dart';
import 'package:provider/provider.dart';

class class_report_screen extends StatelessWidget {
  const class_report_screen({super.key});
  static const RouteName = '/class_report_screen';

  @override
  Widget build(BuildContext context) {
    final classId = ModalRoute.of(context)!.settings.arguments;
    final providerData = Provider.of<totalRecordProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Report"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: providerData
            .getDistinctDatesByClassId(int.parse(classId.toString())),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Please take Attandance first'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final date = snapshot.data![index];

                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Center(child: Text(date)),
                    subtitle: FutureBuilder<int>(
                      future: providerData.countStudentsPresentByDate(
                        int.parse(classId.toString()),
                        date.toString(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('No. of present: Loading...');
                        } else if (snapshot.hasError) {
                          return const Text('No. of present: Error');
                        } else if (snapshot.hasData) {
                          final studentsPresent = snapshot.data;
                          return Text('No. of present: $studentsPresent');
                        } else {
                          return const Text(
                              'No. of present: N/A'); // Show "Not Available" if data is not found
                        }
                      },
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          individual_report_screen.RouteName,
                          arguments: {
                            'class_id': classId,
                            'date': date,
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.edit_note_outlined,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
