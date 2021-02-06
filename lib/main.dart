import 'package:am_sliit/index.dart';
import 'package:am_sliit/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth.instance
      .authStateChanges()
      .listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      runApp(LoadIndexPage());
    }
  });

  runApp(MyApp());
}




DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWelcomePage(),
    );
  }

}

class LoadIndexPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    );
  }

}