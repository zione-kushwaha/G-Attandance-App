// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class date_time_now extends StatelessWidget {
  final String nepaliFormattedDate;
  final String formattedDate;

  const date_time_now(
      {super.key,
      required this.formattedDate,
      required this.nepaliFormattedDate});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Card(
        elevation: 20,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFF59F87).withOpacity(0.5),
                const Color(0xFFF59F87).withOpacity(0.7),
                const Color(0xFFF59F87).withOpacity(0.9)
              ],
              end: Alignment.topLeft,
              begin: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                '   $formattedDate   ',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              Text(
                '   $nepaliFormattedDate   ',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
