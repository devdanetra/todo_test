/*
 * Copyright (c) 2021. Francesco D'anetra (@devdanetra | devdanetra@outlook.com)
 */
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_test_for_apey/pages/AuthPage.dart';
import 'package:todo_test_for_apey/pages/TodoPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Todo App - Apey Test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          primaryColorLight: Colors.lightBlue,
          primarySwatch: Colors.lightBlue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        getPages: [
          GetPage(name: '/', page: () => MyApp()),
          GetPage(name: '/auth', page: () => AuthPage()),
          GetPage(name: '/todo', page: () => TodoPage()),
    ],
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Scaffold(
                  body: Center(
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Text(
                            "Errore durante la connessione al server, ritenta l' accesso più tardi.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            ),
                          ))));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return AuthPage();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
