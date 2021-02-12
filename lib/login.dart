


import 'package:am_sliit/index.dart';
import 'package:am_sliit/register.dart';
import 'package:am_sliit/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:am_sliit/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'package:flutter/src/widgets/framework.dart';



class LoginScreen extends StatelessWidget {




  final Color primaryColor = Color(0xff00007b);
  final Color secondaryColor = Colors.indigo[700];

  final Color logoGreen = Color(0xffD0752c);

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
                  'Welcome to AM SLIIT',
                  textAlign: TextAlign.center,
                  style:
                  GoogleFonts.openSans(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Image.asset(
                    'assets/register.png',
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: 20,
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
                    if(emailController.text.isEmpty || passwordController.text.isEmpty){
                      displayToastMessage("All the fields are mandatory", context);
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
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  child: Text(
                    "Don't Have an Account? Sign Up Now",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ResetPasswordScreen()));
                  },
                  child: Text(
                    "Forgotten Password",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 60),
                Align(
                  alignment: Alignment.bottomCenter,
                 // child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
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
           //verification is not working
           // MaterialPageRoute(builder: (_) => LoadWelcomePage()));
            MaterialPageRoute(builder: (_) => IndexPage()));
      }
    });

  }




  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }




}
