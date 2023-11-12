// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';

class drawer_item extends StatelessWidget {
  final String text;
  final Icon iconss;
  final Color? colors;
  const drawer_item(
      {super.key, required this.iconss, required this.text, this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.all(8)),
        iconss,
        const SizedBox(
          width: 25,
        ),
        Text(
          text,
          style: TextStyle(color: colors, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
