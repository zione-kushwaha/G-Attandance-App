// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '/providers/class_modal.dart';
import '/screens/class_name_code.dart';
import '/widgets/popup_menu_bottom.dart';
import '../providers/total_record.dart';
import 'package:provider/provider.dart';

class first_screen_with_data extends StatelessWidget {
  const first_screen_with_data({super.key});

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<ClassModelProvider>(context);
    List<Color> gridColors = [Colors.red, Colors.green, Colors.pink];
    int gridColorIndex = 0;

    return Expanded(
      child: FutureBuilder(
        future: providerData.getClassModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // Render the data when it's available
            List<ClassModel>? classModels = snapshot.data;
            return ListView.builder(
              itemCount: classModels!.length,
              itemBuilder: (context, index) {
                // Determine whether the card is even or odd
                bool isOdd = index.isOdd;

                // Use the grid color and increment the index
                Color gridColor = gridColors[gridColorIndex];
                gridColorIndex = (gridColorIndex + 1) % gridColors.length;

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, class_name_code.NamedRoute,
                        arguments: {
                          'id': classModels[index].id,
                          'classS_id': classModels[index].class_id,
                          'class_name': classModels[index].class_name
                        });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isOdd
                                ? [
                                    gridColor.withOpacity(0.8),
                                    gridColor.withOpacity(0.4),
                                  ]
                                : [
                                    gridColor.withOpacity(0.4),
                                    gridColor.withOpacity(0.8),
                                  ],
                            end: Alignment.topLeft,
                            begin: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 40,
                              left: 40,
                              child: Text(
                                'Class Name: ${classModels[index].class_name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 75,
                              left: 60,
                              child: Text(
                                'Class ID:  ${classModels[index].class_id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 150,
                              left: 70,
                              child: FutureBuilder(
                                future:
                                    Provider.of<totalRecordProvider>(context)
                                        .getTotalAttendanceDays(int.parse(
                                            classModels[index].id.toString())),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Display a loading indicator while waiting for the result.
                                  } else if (snapshot.hasData) {
                                    int totalDays = snapshot.data!;
                                    return Text(
                                      'Total days: $totalDays',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                        'Total days: N/A'); // Display an error message or fallback text if there's an issue.
                                  }
                                },
                              ),
                            ),
                            Positioned(
                              top: 30,
                              right: 10,
                              child: popup_menu_bottom(xyz: classModels[index]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('No data available.');
          }
        },
      ),
    );
  }
}
