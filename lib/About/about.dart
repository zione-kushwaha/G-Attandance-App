// ignore_for_file: depend_on_referenced_packages, constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  static const RouteName = '/about';

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'App Developer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                backgroundImage: AssetImage('lib/assets/zione_photo.jpg'),
                radius: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Jeevan Kumar Kushwaha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF59F87),
                ),
              ),
              const ListTile(
                leading: Text(
                  'Contact information:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.email, size: 32, color: Colors.blue),
                title: InkWell(
                  onTap: () {
                    launch('mailto:zionekushwaha@gmail.com');
                  },
                  child: const Text('zionekushwaha@gmail.com'),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone, size: 32, color: Colors.green),
                title: InkWell(
                  onTap: () {
                    launch('tel:+9779807151008');
                  },
                  child: const Text('+977 980-7151008'),
                ),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.linkedin,
                    size: 32, color: Colors.indigo),
                title: InkWell(
                  onTap: () {
                    launch(
                        'https://www.linkedin.com/in/zi-one?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app');
                  },
                  child: const Text('Linkin profile link'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
