import 'package:am_sliit/index.dart';
import 'package:am_sliit/login.dart';
import 'package:am_sliit/register.dart';
import 'package:am_sliit/verify_email_to_continue.dart';
import 'package:am_sliit/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.storage.request();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null ) {
      //this is a new visitor
      //load greeting page
      runApp(LoadWelcomePage());
    }else if(user != null && !user.emailVerified){
      //user signed In but not verified email
      //load email verification page
      runApp(LoadEmailVerifyPage());
    }else if (user != null && user.emailVerified) {
      //user signed In and verified his email
      //load cWeb Page
      runApp(LoadIndexPage());
    }
  });

  runApp(MyWelcomePage());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");


//load greeting message
class LoadWelcomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWelcomePage(),
    );
  }

}

//load index page (cWeb page)
class LoadIndexPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IndexPage(),
    );
  }

}

//load login page
class LoadLoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }

}

//load email verification message page
class LoadEmailVerifyPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VerifyEmailToContinue(),
    );
  }

}





displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}