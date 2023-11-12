// ignore_for_file: use_build_context_synchronously, constant_identifier_names, non_constant_identifier_names
import 'package:flutter/material.dart';
import '/providers/studentModel.dart';
import '/providers/total_record.dart';
import '/widgets/start_attandance_widget.dart';
import 'package:provider/provider.dart';

class StartAttendanceScreen extends StatefulWidget {
  const StartAttendanceScreen({Key? key}) : super(key: key);
  static const RouteName = '/start_attendance';

  @override
  State<StartAttendanceScreen> createState() => _StartAttendanceScreenState();
}

class _StartAttendanceScreenState extends State<StartAttendanceScreen> {
  bool temp = false;
  int classId = 0;
  List<bool> isPresentList = [];
  int dataLength = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final map = ModalRoute.of(context)!.settings.arguments as Map;
    classId = map['class_id'];
  }

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)!.settings.arguments as Map;
    final date = map['date'];
    final class_name = map['class_name'];

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text('Start Attendance'),
        centerTitle: true,
        actions: [
          Switch(
            value: temp,
            onChanged: (value) {
              setState(() {
                temp = value;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            color: const Color.fromARGB(255, 242, 237, 156),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Roll no'),
                Text('Student Name'),
                Text('Present'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<student_model>>(
              future: Provider.of<studentMOdelProvider>(context)
                  .getStudentsByClassId(classId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle the case where there are no students
                  return const Center(child: Text('No students found'));
                } else {
                  List<student_model>? studentsList = snapshot.data;
                  isPresentList = List.filled(snapshot.data!.length, temp);
                  return StartAttendanceWidget(
                    classId: classId,
                    ispresent: isPresentList,
                    studentsList: studentsList!,
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () async {
            List<student_model> studentsList =
                await Provider.of<studentMOdelProvider>(context, listen: false)
                    .getStudentsByClassId(classId);
            List<totalRecord> record = [];
            for (int i = 0; i < studentsList.length; i++) {
              record.add(totalRecord(
                name: studentsList[i].name,
                classname: class_name.toString(),
                rollno: studentsList[i].rollno,
                ispresent: isPresentList[i] ? 1 : 0,
                date: date,
                uniquekey: classId,
              ));
            }
            await Provider.of<totalRecordProvider>(context, listen: false)
                .insertRecords(record, context);
          },
          icon: const Icon(
            Icons.save,
            color: Colors.white,
          ),
          label: const Text('Save'),
        ),
      ),
    );
  }
}
