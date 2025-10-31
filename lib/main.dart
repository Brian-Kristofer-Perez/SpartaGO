import 'package:flutter/material.dart';
import 'package:sparta_go/Helpers/LocalFileHelper.dart';
import 'package:sparta_go/pages/equipment/equipment.dart';
import 'package:sparta_go/pages/facilities/facilities.dart';
import 'package:sparta_go/pages/equipment-borrow-request/EquipmentBorrowRequestPage.dart';
import 'package:sparta_go/pages/facility-borrow-request/FacilityBorrowRequestPage.dart';
import 'package:sparta_go/pages/login/login-page.dart';
import 'package:sparta_go/pages/view-events/ViewEventsPage.dart';

import 'common/back_button.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Reset storage for testing
  await LocalFileHelper.resetStorage();

  // Reinitialize from assets
  await LocalFileHelper.reinitializeFiles([
    'equipment.json',
    'facilities.json',
    'equipment_reservations.json',
    'facility_reservations.json',
    'autoincrement_data.json',
    'users.json'
  ]);

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
          '/': (context) => LoginPage()
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
