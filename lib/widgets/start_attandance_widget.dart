import 'package:flutter/material.dart';
import '/providers/studentModel.dart';

// ignore: must_be_immutable
class StartAttendanceWidget extends StatefulWidget {
  final int classId;
  List<bool> ispresent;
  List<student_model> studentsList;

  StartAttendanceWidget({
    super.key,
    required this.classId,
    required this.ispresent,
    required this.studentsList,
  });

  @override
  State<StartAttendanceWidget> createState() => _StartAttendanceWidgetState();
}

class _StartAttendanceWidgetState extends State<StartAttendanceWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.studentsList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(widget.studentsList[index].rollno.toString()),
            ),
            title: Center(
              child: Text(widget.studentsList[index].name ?? ''),
            ),
            trailing: IconButton(
              icon: widget.ispresent[index]
                  ? const Icon(Icons.check_box, color: Colors.green)
                  : const Icon(Icons.crop_square_sharp, color: Colors.red),
              onPressed: () {
                setState(() {
                  widget.ispresent[index] = !widget.ispresent[index];
                });
              },
            ),
          ),
        );
      },
    );
  }
}
