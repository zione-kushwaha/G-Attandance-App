import 'package:flutter/material.dart';
import '/providers/class_modal.dart';
import '/screens/drawer_screen.dart';
import '/screens/first_screen_with_data.dart';
import '/widgets/front_page_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import '../widgets/date_time_now.dart';
import 'modal_bottom_sheet.dart';

// ignore: camel_case_types
class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  int retryAttempts = 0;
  @override
  Widget build(BuildContext context) {
    NepaliDateTime nepaliDate = NepaliDateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());
    String nepaliFormattedDate =
        NepaliDateFormat('d MMMM y').format(nepaliDate);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Classes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(
        child: drawer_screen(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            date_time_now(
              nepaliFormattedDate: nepaliFormattedDate,
              formattedDate: formattedDate,
            ),
            FutureBuilder<List<ClassModel>>(
              future: Provider.of<ClassModelProvider>(context).getClassModels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  if (retryAttempts < 1) {
                    // Retry fetching data after a delay
                    Future.delayed(const Duration(microseconds: 1), () {
                      setState(() {
                        retryAttempts++;
                      });
                    });
                    return const CircularProgressIndicator();
                  } else {
                    return Text('Failed to load data: ${snapshot.error}');
                  }
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const front_page_image();
                } else {
                  return const first_screen_with_data();
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return ModelBottomSheet();
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
