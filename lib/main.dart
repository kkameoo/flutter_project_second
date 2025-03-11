import 'package:flutter/material.dart';
import 'package:flutter_project_second/home.dart';
import 'package:flutter_project_second/list.dart';
import 'package:flutter_project_second/addNumber.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Phone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: "/",
      routes: {"/": (context) => HomeForm(), "/list": (context) => ContactListPage(),

      },
    );
  }
}
