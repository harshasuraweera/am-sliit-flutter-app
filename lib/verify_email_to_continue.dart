import 'package:am_sliit/login.dart';
import 'package:am_sliit/register.dart';
import 'package:am_sliit/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'main.dart';

class VerifyEmailToContinue extends StatefulWidget{
  @override
  _MyVerifyEmailToContinue createState() => _MyVerifyEmailToContinue();
}

class _MyVerifyEmailToContinue extends State<VerifyEmailToContinue>{
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
              'Please verify your email to continue',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20),
            Text(
              'To prevent unwanted persons using this application you must verify your email address',
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
                resendVerificationEmail(context);
              },
              color: Color(0xffD0752c),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Send Verification Link',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  SizedBox(width: 10,),
                  Icon(Icons.email)
                ],
              ),
              textColor: Colors.white,
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                EmailVerifiedByMe(context);
              },
              child: Text(
                "I just verified and let me Sign In",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteCurrentAccountAndCreateNewOne(context);
              },
              child: Text(
                "Let me create a New Account",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
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
      MaterialPageRoute(builder: (_) => LoadWelcomePage()));
}

void resendVerificationEmail(BuildContext context)  {
  User user = FirebaseAuth.instance.currentUser;
  user.sendEmailVerification();

}

void EmailVerifiedByMe(BuildContext context){

  Navigator.push(context,
      MaterialPageRoute(builder: (_) => LoginScreen()));
}

void deleteCurrentAccountAndCreateNewOne(BuildContext context) async {

  try {
    await FirebaseAuth.instance.signOut();
  }  on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
    print('The user must reauthenticate before this operation can be executed.');
    }
  }




}