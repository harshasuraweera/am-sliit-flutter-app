import 'package:am_sliit/login.dart';
import 'package:am_sliit/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IndexPage extends StatefulWidget{
  @override
  _MyIndexPage createState() => _MyIndexPage();
}

class _MyIndexPage extends State<IndexPage>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff00007b),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //We take the image from the assets
            Center(
              child: Image.asset(
                'assets/university.png',
                height: 250,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //Texts and Styling of them
            Text(
              'You are done thanks for register',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20),
            Text(
              'It is now easy to access every tool in once place and manage daily academic tasks!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              elevation: 0,
              height: 50,
              onPressed: () {
                signOutNow(context);
              },
              color: Color(0xffD0752c),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Log Out',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              textColor: Colors.white,
            )
            //Our MaterialButton which when pressed will take us to a new screen named as
            //LoginScreen
          ],
        ),
      ),
    );
  }
}



Future<void> signOutNow (BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.push(context,
      MaterialPageRoute(builder: (_) => MyWelcomePage()));
}