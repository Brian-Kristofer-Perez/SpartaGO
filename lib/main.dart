import 'package:flutter/material.dart';
import 'package:sparta_go/pages/facilities/court_facilities.dart';
import 'package:sparta_go/pages/facilities/facilities.dart';
import 'package:sparta_go/pages/facilities/gym_facilities.dart';
import 'package:sparta_go/pages/login/login-page.dart';
import 'package:sparta_go/pages/sign-up/progress-item.dart';
import 'common/back_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
          '/': (context) => FacilitiesPage(),
          // '/about': (context) => AboutPage(),
        },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF991B1B)).copyWith(
          primary: const Color(0xFF991B1B),
          secondary: Colors.black,
          background: Colors.white,
          surface: Colors.white,
          onBackground: Colors.black,
          onSurface: const Color(0xFF444444), // muted text
          outline: const Color(0xFFC6C6C6),
          surfaceVariant: const Color(0xFFD9D9D9), // darker-bg
          primaryContainer: const Color(0xFFEFDEDE), // lighter primary
        ),
      ),
    );
  }
}
