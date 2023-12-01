// ignore_for_file: camel_case_types

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '/providers/total_record.dart';
import '/widgets/individual_widget.dart';
import 'package:provider/provider.dart';

class individual_report_screen extends StatelessWidget {
  const individual_report_screen({super.key});
  static const RouteName = './individual_report_screen';

  @override
  Widget build(BuildContext context) {
    List<int> ispresent = [];
    List<String> name = [];
    List<int> rollno = [];
    final map = ModalRoute.of(context)!.settings.arguments as Map;
    final class_id = map['class_id'];
    final date = map['date'];
    final providerdata =
        Provider.of<totalRecordProvider>(context, listen: false);
    return FutureBuilder(
      future: providerdata.getRecordsByClassIdAndDate(class_id, date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(date),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(date),
              centerTitle: true,
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.length; i++) {
            ispresent.add(snapshot.data![i].ispresent);
            name.add(snapshot.data![i].name.toString());
            rollno.add(snapshot.data![i].rollno);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(date),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  color: const Color.fromARGB(255, 200, 240, 134),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Text('Roll no:'), Text('Name'), Text('Present')],
                  ),
                ),
                Expanded(
                  child: IndividualWidget(
                    name: name,
                    rollno: rollno,
                    isPresentList: ispresent,
                  ),
                ),
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Are you sure to Update?',
                      desc: 'This Action gonna modify your existing record... ',
                      btnOkOnPress: () {
                        Provider.of<totalRecordProvider>(context, listen: false)
                            .updateRecords(
                                rollno, name, ispresent, class_id, date);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.lightBlue,
                            content: Text('Record Modified successfully!!!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  heroTag: 'button1',
                  child: const Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 25),
                FloatingActionButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Are you sure to delete?',
                      desc: 'Deleted data can\'t be recovered... ',
                      btnOkOnPress: () {
                        providerdata.deleteRecordsByClassIdAndDate(
                            class_id, date, context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.lightBlue,
                            content: Text('Record Deleted successfully!!!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      btnCancelOnPress: () {},
                    ).show();
                  },
                  heroTag: 'button2',
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(date),
              centerTitle: true,
            ),
            body: const Center(child: Text('No data available')),
          );
        }
      },
    );
  }
}
