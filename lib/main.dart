import 'package:firebase_core/firebase_core.dart';
import 'package:third_flutter/firebase_options.dart';
import 'package:third_flutter/home_page.dart';
import 'package:third_flutter/login_page.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Mirambel CRUD App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ); // Scaffold
          }

          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LoginPage();
          }
        },
      ), // StreamBuilder
    ); // MaterialApp
  }
}
