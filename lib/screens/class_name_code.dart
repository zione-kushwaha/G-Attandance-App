// ignore_for_file: camel_case_types, constant_identifier_names, library_private_types_in_public_api, deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import '/screens/add_record.dart';
import '/screens/class_report.dart';
import '/screens/start_attandance.dart';
import '/screens/student_report.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../widgets/date_time_now.dart';
import '../widgets/class_name_widget.dart';

class class_name_code extends StatefulWidget {
  const class_name_code({super.key});

  static const NamedRoute = '/class_name_code';

  @override
  _class_name_codeState createState() => _class_name_codeState();
}

class _class_name_codeState extends State<class_name_code> {
  DateTime selectedDate = DateTime.now();
  NepaliDateTime nepaliDate = NepaliDateTime.now();
  String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
  String nepaliFormattedDate =
      NepaliDateFormat('d MMMM y').format(NepaliDateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        nepaliDate = NepaliDateTime.fromDateTime(selectedDate);
        formattedDate = DateFormat('EEEE, MMMM d, y').format(selectedDate);
        nepaliFormattedDate = NepaliDateFormat('d MMMM y').format(nepaliDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)!.settings.arguments as Map;
    final id = map['id'];
    return FutureBuilder<String>(
      future: Future.value(map['class_name'].toString()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final class_name = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text(snapshot.data.toString()),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  date_time_now(
                      formattedDate: formattedDate,
                      nepaliFormattedDate: nepaliFormattedDate),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: Card(
                      child: Container(
                        height: 40,
                        color: const Color(0xFFF59F87),
                        width: double.infinity,
                        child: const Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 12)),
                            Icon(
                              Icons.edit_calendar,
                            ),
                            Expanded(
                                child: Center(child: Text('Choose new date'))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, StartAttendanceScreen.RouteName, arguments: {
                        'date': formattedDate,
                        'class_id': id,
                        'class_name': class_name
                      });
                    },
                    child: class_name_widget(
                      iconss: const Icon(
                        Icons.check_box,
                        color: Colors.white,
                      ),
                      text: 'Start Attendance',
                      colors: [
                        Colors.green.withOpacity(0.9),
                        Colors.green.withOpacity(0.7),
                        Colors.green.withOpacity(0.4)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, add_record.RouteName,
                          arguments: {
                            'class_name': class_name,
                            'date': formattedDate,
                            'class_id': id
                          });
                    },
                    child: class_name_widget(
                      iconss: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      text: 'Add record',
                      colors: [
                        Colors.pink.withOpacity(0.8),
                        Colors.pink.withOpacity(0.6),
                        Colors.pink.withOpacity(0.4)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, student_report.NamedRoute,
                          arguments: id);
                    },
                    child: class_name_widget(
                      iconss: const Icon(
                        Icons.description,
                        color: Colors.white,
                      ),
                      text: 'Student report',
                      colors: [
                        Colors.red.withOpacity(0.9),
                        Colors.red.withOpacity(0.7),
                        Colors.red.withOpacity(0.4)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, class_report_screen.RouteName,
                          arguments: id);
                    },
                    child: class_name_widget(
                      iconss: const Icon(
                        Icons.bar_chart_outlined,
                        color: Colors.white,
                      ),
                      text: 'Class report',
                      colors: [
                        Colors.yellow.withOpacity(0.9),
                        Colors.yellow.withOpacity(0.7),
                        Colors.yellow.withOpacity(0.4)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, StartAttendanceScreen.RouteName,
                    arguments: {
                      'date': formattedDate,
                      'class_id': id,
                      'class_name': class_name
                    });
              },
              label: const Text('Attendance'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              backgroundColor: const Color(0xFFF59F87),
              icon: const Icon(
                Icons.add_circle,
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}
