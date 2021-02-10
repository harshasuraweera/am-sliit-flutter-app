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
import 'package:cool_stepper/cool_stepper.dart';
import 'index.dart';
import 'login.dart';



class RegisterScreen extends StatelessWidget {
  final Color primaryColor = Color(0xff00007b);
  final Color secondaryColor = Colors.indigo[700];

  final Color logoGreen = Color(0xffD0752c);

  final TextEditingController nameController = TextEditingController();
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
                  'Register On Here',
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
                    nameController, Icons.account_circle, 'Name'),
                SizedBox(height: 20),
                _buildTextField(
                    emailController, Icons.account_circle, 'Email'),
                SizedBox(height: 20),
                _buildTextField(passwordController, Icons.lock, 'Password'),
                SizedBox(height: 50),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 50,
                  onPressed: () {
                    if(nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty){
                      displayToastMessage("All the fields are mandatory", context);
                    }else if(!emailController.text.endsWith("sliit.lk")){
                      displayToastMessage("Please use your SLIIT email", context);
                    }else if(passwordController.text.length < 4){
                      displayToastMessage("Password is too short", context);
                    }else{
                      registerNewUser(context);
                    }
                  },
                  color: logoGreen,
                  child: Text('Register Now',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                SizedBox(height: 80),
                Align(
                  alignment: Alignment.bottomCenter,
                 // child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }

  // _buildFooterLogo() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //
  //       Text('App By ',
  //           textAlign: TextAlign.center,
  //           style: GoogleFonts.openSans(
  //               color: Colors.white,
  //               fontSize: 20,
  //               fontWeight: FontWeight.bold)),
  //       Image.asset(
  //         'assets/evox_white.png',
  //         height: 40,
  //       ),
  //     ],
  //   );
  // }

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

  void registerNewUser(BuildContext context) async {
    final User firebaseUser = (await _firebaseAuth
      .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text
    ).catchError((errMsg){
      displayToastMessage("error " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null){ //user created

      Map userDataMap = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);

      displayToastMessage("Account created", context);

      Navigator.push(context,
          MaterialPageRoute(builder: (_) => LoginScreen()));

      FirebaseAuth.instance.signOut();

    }else{ //user not created
      displayToastMessage("user has not created", context);
    }

  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }



}

