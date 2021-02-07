
import 'dart:ffi';
import 'dart:io';
import 'package:am_sliit/login.dart';
import 'package:am_sliit/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'main.dart';

class IndexPage extends StatefulWidget{
  @override
  _MyIndexPage createState() => _MyIndexPage();
}

class _MyIndexPage extends State<IndexPage>{

  String url = "http://courseweb.sliit.lk/my/";
  String title = "CourseWeb";

  final Color logoGreen = Color(0xffD0752c);
  WebViewController _controller;



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
              onPressed: (){
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
                  _controller.loadUrl('http://courseweb.sliit.lk/my/');

                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Student Profile'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  _controller.loadUrl('https://study.sliit.lk/');

                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
       body: WebView(
         initialUrl: "https://courseweb.sliit.lk/my/",
         onWebViewCreated: (WebViewController webViewController) {
           _controller = webViewController;
         },
       ),
      ),
    );
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



