import 'package:flutter/material.dart';
import '/About/about.dart';
import 'providers/class_modal.dart';
import 'providers/studentModel.dart';
import 'providers/total_record.dart';
import 'screens/add_record.dart';
import 'screens/class_name_code.dart';
import 'screens/class_report.dart';
import 'screens/first.dart';
import 'screens/start_attandance.dart';
import 'screens/student_report.dart';
import 'package:provider/provider.dart';
import './screens/individual_report_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClassModelProvider()),
        ChangeNotifierProvider(create: (_) => studentMOdelProvider()),
        ChangeNotifierProvider(create: (_) => totalRecordProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'fontstyle',
          primarySwatch: const MaterialColor(
            0xFFF59F87,
            <int, Color>{
              50: Color(0xFFF59F87),
              100: Color(0xFFF59F87),
              200: Color(0xFFF59F87),
              300: Color(0xFFF59F87),
              400: Color(0xFFF59F87),
              500: Color(0xFFF59F87),
              600: Color(0xFFF59F87),
              700: Color(0xFFF59F87),
              800: Color(0xFFF59F87),
              900: Color(0xFFF59F87),
            },
          ),
        ),
        home: const First(),
        routes: {
          class_name_code.NamedRoute: (context) => const class_name_code(),
          add_record.RouteName: (context) => add_record(),
          StartAttendanceScreen.RouteName: (context) =>
              const StartAttendanceScreen(),
          class_report_screen.RouteName: (context) =>
              const class_report_screen(),
          student_report.NamedRoute: (context) => const student_report(),
          individual_report_screen.RouteName: (context) =>
              const individual_report_screen(),
          AboutScreen.RouteName: (context) => const AboutScreen(),
        },
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              switch (settings.name) {
                case class_name_code.NamedRoute:
                  return const class_name_code();
                case add_record.RouteName:
                  return add_record();
                case StartAttendanceScreen.RouteName:
                  return const StartAttendanceScreen();
                case class_report_screen.RouteName:
                  return const class_report_screen();
                case student_report.NamedRoute:
                  return const student_report();
                case individual_report_screen.RouteName:
                  return const individual_report_screen();
                case AboutScreen.RouteName:
                  return const AboutScreen();
                default:
                  return const First();
              }
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.bounceInOut;
              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );
              var offset = animation.drive(tween);
              return SlideTransition(
                position: offset,
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}
