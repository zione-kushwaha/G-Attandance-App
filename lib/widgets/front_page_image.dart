// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class front_page_image extends StatelessWidget {
  const front_page_image({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
            'lib/assets/front_page.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
