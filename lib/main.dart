import 'package:flutter/material.dart';
import 'package:caphe_v2/screens/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:caphe_v2/screens/about.dart';

// Requires that the Firebase Auth emulator is running locally
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAPHE',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.blue,
      ),
      home: Root(),
    );
  }
}

