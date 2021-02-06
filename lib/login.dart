

import 'dart:ffi';

import 'package:am_sliit/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:am_sliit/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'index.dart';
import 'login.dart';

import 'package:flutter/src/widgets/framework.dart';


class LoginScreen extends StatelessWidget {
  final Color primaryColor = Color(0xff00007b);
  final Color secondaryColor = Colors.indigo[700];

  final Color logoGreen = Color(0xffD0752c);

  final TapGestureRecognizer _openRegisterPage = TapGestureRecognizer()..onTap = () {

    //Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
  };



  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: primaryColor,
        body: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Sign In to AM SLIIT',
                  textAlign: TextAlign.center,
                  style:
                  GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                ),
                SizedBox(
                  height: 50,
                ),
                _buildTextField(
                    emailController, Icons.account_circle, 'Email'),
                SizedBox(height: 20),
                _buildTextField(passwordController, Icons.lock, 'Password'),
                SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {
                    if(emailController.text.isEmpty){
                      displayToastMessage("fill the name", context);
                    }else if(passwordController.text.isEmpty){
                      displayToastMessage("fill the password", context);
                    }else{
                      loginUser(context);
                    }
                  },
                  color: logoGreen,
                  child: Text('Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                SizedBox(height: 20),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      Expanded(child: MaterialButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => RegisterScreen()));
                        },
                        child: Text("Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 16)
                        ),
                        elevation: 0,
                        height: 50,
                        color: secondaryColor,
                      )
                      ),
                      SizedBox(width: 20),
                      // ignore: deprecated_member_use
                      Expanded(child: MaterialButton(
                        onPressed: () {},
                        child: Text("Reset Password",
                            style: TextStyle(color: Colors.white, fontSize: 16)
                        ),
                        elevation: 0,
                        height: 50,
                        color: secondaryColor,
                      )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text('App By ',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Image.asset(
          'assets/evox_white.png',
          height: 40,
        ),
      ],
    );
  }

  _buildTextField(
      TextEditingController controller, IconData icon, String labelText) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: secondaryColor, border: Border.all(color: Colors.blue)),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white),
            icon: Icon(
              icon,
              color: Colors.white,
            ),
            // prefix: Icon(icon),
            border: InputBorder.none),
      ),
    );
  }


  //register new user with firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayToastMessage("No user found for that email", context);
      } else if (e.code == 'wrong-password') {
        displayToastMessage("Wrong password provided for that user", context);
      }
    }

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        displayToastMessage("User is signed in!", context);
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => IndexPage()));
      }
    });

  }




  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }




}
