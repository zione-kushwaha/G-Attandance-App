// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class class_name_widget extends StatelessWidget {
  final String text;
  final Icon iconss;
  final List<Color> colors;
  const class_name_widget(
      {super.key,
      required this.iconss,
      required this.text,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: colors,
          end: Alignment.topLeft,
          begin: Alignment.bottomRight,
        )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Align children to the start and end
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(text),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: iconss,
            ),
          ],
        ),
      ),
    );
  }
}
