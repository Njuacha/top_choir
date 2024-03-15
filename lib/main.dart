import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:top_choir/screens/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo).copyWith(background: const Color(0xFFEFEFEF)),
        filledButtonTheme: FilledButtonThemeData(style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12)
        ))
      ),
      home: const AuthGate(),
    );
  }
}
