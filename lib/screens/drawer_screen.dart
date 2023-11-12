// ignore_for_file: camel_case_types, deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import '/providers/total_record.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '/About/about.dart';
import '../widgets/drawer_item.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/widgets.dart' as pw;

class drawer_screen extends StatelessWidget {
  const drawer_screen({super.key});

  Future<void> _showPlayStoreLinkDialog(BuildContext context) {
    const playStoreLink =
        'https://play.google.com/store/apps/details?id=your_package_name_here'; // Replace with your Play Store link

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Share App'),
          content: const Text('Share app Link of the playstore'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Share'),
              onPressed: () {
                Share.share(
                    'Check out my app on the Play Store: $playStoreLink');
              },
            ),
          ],
        );
      },
    );
  }

//rate app in the playstore
  Future<void> _rateApp() async {
    const playStoreLink =
        'https://play.google.com/store/apps/details?id=your_package_name_here'; // Replace with your Play Store link

    await launch(playStoreLink);
  }

  //send message
  Future<void> _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'zionekushwaha@gmail.com',
      queryParameters: {
        'subject': 'Regarding G-Attendance App',
        'body': 'Your message goes here.\n\n',
      },
    );

    try {
      await launch(emailLaunchUri.toString());
    } catch (e) {
      //
    }
  }

  Future<void> exportAndShareRecords(
      String tableName, BuildContext context) async {
    try {
      final records =
          await Provider.of<totalRecordProvider>(context, listen: false)
              .getAllRecords();
      int i = 1;
      // Create a PDF document
      final pdf = pw.Document();

      // Create a list to hold rows for all records
      final List<List<String>> tableData = [];

      // Add headers to the table
      tableData
          .add(['SN.', 'Name', 'Roll No', 'Is Present', 'Date', 'Class Name']);

      // Add rows for each record
      for (final record in records) {
        tableData.add([
          ('${i++}').toString(),
          record.name ?? '',
          record.rollno.toString(),
          record.ispresent.toString(),
          record.date,
          record.classname,
          '' // Assuming 'className' is the column storing class name
        ]);
      }
      // Add pages with tables, considering page breaks
      const int maxRowsPerPage = 30; // Adjust as needed
      for (int i = 0; i < tableData.length; i += maxRowsPerPage) {
        final int endIndex = (i + maxRowsPerPage) < tableData.length
            ? (i + maxRowsPerPage)
            : tableData.length;

        final List<List<String>> currentPageData =
            tableData.sublist(i, endIndex);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) => pw.Table.fromTextArray(
              data: currentPageData,
            ),
          ),
        );
      }

      // Save the PDF to a temporary file with the custom filename
      final directory = await getTemporaryDirectory();
      final filePath = join(directory.path, 'G_attendance.pdf');
      await File(filePath).writeAsBytes(await pdf.save());

      // Share the PDF file with the specified custom filename
      await Share.shareFiles([filePath],
          text: 'Sharing exported $tableName records',
          subject: 'Exported Records');
    } catch (e) {
      //b
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 180,
                color: const Color(0xFFF59F87),
              ),
              Positioned(
                left: 100,
                top: 50,
                child: Card(
                  elevation: 7,
                  child: Image.asset(
                    'lib/assets/logi_img.png',
                    height: 70,
                    width: 80,
                  ),
                ),
              ),
              const Positioned(
                right: 70,
                top: 135,
                child: Text(
                  'G-Attandance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
              showLicensePage(context: context);
            },
            child: const drawer_item(
              iconss: Icon(
                Icons.key,
                color: Color.fromARGB(255, 162, 159, 159),
              ),
              text: 'License info',
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
              _sendEmail();
            },
            child: const drawer_item(
              iconss: Icon(
                Icons.send,
                color: Color.fromARGB(255, 76, 122, 175),
              ),
              text: 'send  message',
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () async {
              exportAndShareRecords('total_record', context);
            },
            child: const drawer_item(
              iconss: Icon(
                Icons.swap_vert,
                color: Color.fromARGB(255, 66, 202, 191),
              ),
              text: 'Import/Export  DB',
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
              _showPlayStoreLinkDialog(context);
            },
            child: const drawer_item(
              iconss: Icon(
                Icons.share,
                color: Colors.blue,
              ),
              text: 'Share  App',
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
              _rateApp();
            },
            child: const drawer_item(
              iconss: Icon(
                Icons.star,
                color: Colors.black,
              ),
              text: 'Rate  App',
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AboutScreen.RouteName);
            },
            child: const drawer_item(
              iconss: Icon(
                Icons.info_outline,
                color: Colors.purple,
              ),
              text: 'About',
            ),
          )
        ],
      ),
    );
  }
}
