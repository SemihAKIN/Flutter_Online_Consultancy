import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';

import 'screens/entry_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase Çalıştır
  await Firebase.initializeApp();
  setupLocater();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<NavigatorService>().navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: EntryScreen());
  }
}
