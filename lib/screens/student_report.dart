// ignore_for_file: camel_case_types, constant_identifier_names, non_constant_identifier_names, deprecated_member_use, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import '/providers/studentModel.dart';
import '/providers/total_record.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/student_report_screen_widget.dart';

class student_report extends StatelessWidget {
  const student_report({super.key});
  static const NamedRoute = '/student_report';
  Future<void> exportAndShareStudentReport(
      int classId, BuildContext context) async {
    try {
      final students =
          await Provider.of<studentMOdelProvider>(context, listen: false)
              .getStudentsByClassId(classId);
      final days =
          await Provider.of<totalRecordProvider>(context, listen: false)
              .getTotalAttendanceDays(classId);

      // Create a PDF document
      final pdf = pw.Document();

      // Create a list to hold rows for all students
      final List<List<String>> studentData = [];
      int i = 1;

      // Add headers to the table
      studentData
          .add(['S.N.', 'Roll No.', 'Name', 'Present/Total', 'Percentage']);

      // Add rows for each student
      for (final student in students) {
        if (i % 25 == 1 && i > 25) {
          final List<String> headerRow = [
            'S.N.',
            'Roll No.',
            'Name',
            'Present/Total',
            'Percentage'
          ];
          studentData.add(headerRow);
        }
        final presentDays =
            await Provider.of<totalRecordProvider>(context, listen: false)
                .countDaysPresent(classId, student.rollno);

        studentData.add([
          '${i++}',
          student.rollno.toString(),
          student.name ?? '',
          '$presentDays/$days',
          '${((presentDays / days) * 100).toStringAsFixed(2)}%'
        ]);
      }

      // Add pages with tables, considering page breaks
      const int maxRowsPerPage = 26;
      for (int i = 0; i < studentData.length; i += maxRowsPerPage) {
        final int endIndex = (i + maxRowsPerPage) < studentData.length
            ? (i + maxRowsPerPage)
            : studentData.length;

        final List<List<String>> currentPageData =
            studentData.sublist(i, endIndex);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              final pageNumber = context.pageNumber;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Table.fromTextArray(
                    data: currentPageData,
                  ),
                  // Add page number to the end of each page
                  pw.Container(
                    alignment: pw.Alignment.centerRight,
                    margin: const pw.EdgeInsets.only(top: 10.0),
                    child: pw.Text(
                      'Page $pageNumber',
                      style: const pw.TextStyle(
                          fontSize: 10, color: PdfColors.red),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }

      // Save the PDF to a temporary file with the custom filename
      final directory = await getTemporaryDirectory();
      final fileName =
          'student_report_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.pdf';
      final filePath = '${directory.path}/$fileName';
      await File(filePath).writeAsBytes(await pdf.save());

      // Share the PDF file with the specified custom filename
      await Share.shareFiles([filePath],
          text: 'Sharing student report', subject: 'Student Report');
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    final class_id = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text('Student report'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.all(8),
            color: const Color.fromARGB(255, 244, 169, 219),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Roll no'),
                Text('Student Name'),
                Text('Present days')
              ],
            ),
          ),
          Expanded(
              child: student_report_screen_widget(
            class_id: int.parse(class_id.toString()),
          ))
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          onPressed: () {
            exportAndShareStudentReport(
                int.parse(class_id.toString()), context);
          },
          icon: const Icon(
            Icons.share,
            color: Colors.white,
          ),
          label: const Text(
            'Share',
          ),
        ),
      ),
    );
  }
}
