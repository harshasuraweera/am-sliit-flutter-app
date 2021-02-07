
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:am_sliit/login.dart';
import 'package:am_sliit/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IndexPage extends StatefulWidget{
  @override
  _MyIndexPage createState() => _MyIndexPage();
}

class _MyIndexPage extends State<IndexPage>{

  String url = "http://courseweb.sliit.lk/";
  String title = "CourseWeb";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color logoGreen = Color(0xffD0752c);
  WebViewController _controller;
  
  TextEditingController _controllerBookmarkTitle = TextEditingController();

  createAddBookmarkAlertDialog (BuildContext context, String currentUrlByUser){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Add this page as a bookmark"),
        content: TextField(
          controller: _controllerBookmarkTitle,
          decoration: InputDecoration(
            hintText: "Give a title",
          ),
        ),
        actions: [
          MaterialButton(
            elevation: 5.0,
            child: Text("Add"),
            onPressed: (){
              String _bookMarkTitle = _controllerBookmarkTitle.text.trim().toString();
              makeThisPageAsBookMark(context, _bookMarkTitle , currentUrlByUser);
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff00007b),
        appBar: AppBar(
          backgroundColor: logoGreen,
          title:  Text(title),
          actions: [
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () async {
                 //String url = await _controller.currentUrl();
                 //Fluttertoast.showToast( msg: url);
                createAddBookmarkAlertDialog(context, await _controller.currentUrl());
              } , // => function();
            ),
          ],
        ),
        drawer: Drawer(
            // Populate the Drawer in the next step.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("Hi, Good " +greeting() + "!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                ),
                decoration: BoxDecoration(
                  color: Color (0xff00007b),
                  ),
                ),
              ListTile(
                title: Text('CourseWeb'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  _controller.loadUrl('http://courseweb.sliit.lk/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Student Portal'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  _controller.loadUrl('https://study.sliit.lk/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Eduscope'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  _controller.loadUrl('https://lecturecapture.sliit.lk/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Online Exams'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  _controller.loadUrl('https://onlineexams.sliit.lk/login/index.php');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Net Exams'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  _controller.loadUrl('https://netexam.sliit.lk/login/index.php');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
       body: WebView(
         initialUrl: "https://courseweb.sliit.lk/my/",
         javascriptMode: JavascriptMode.unrestricted,
         onWebViewCreated: (WebViewController webViewController) {
           _controller = webViewController;
         },
       ),
      ),
    );
  }

  void makeThisPageAsBookMark(BuildContext context, String bookmarkTitle, String bookMarkUrl) {

    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;

    Map bookmarkDetails = {
      "bookmarkTitle": bookmarkTitle,
      "bookMarkUrl": bookMarkUrl,
    };

    DatabaseReference bookmarkRef = FirebaseDatabase.instance.reference().child("bookmarks");
    bookmarkRef.child(uid).child(_randomString(10)).set(bookmarkDetails);

  }



}





String greeting() {

  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}

String _randomString(int length) {
  var rand = new Random();
  var codeUnits = new List.generate(
      length,
          (index){
        return rand.nextInt(33)+89;
      }
  );

  return new String.fromCharCodes(codeUnits);
}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}
