import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'SpartaGo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

      ),
    );
  }
}
