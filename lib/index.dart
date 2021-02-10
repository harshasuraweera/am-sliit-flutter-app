
import 'dart:math';
import 'package:am_sliit/bookmark_screens/bookmarks.dart';
import 'package:am_sliit/timetable_screens/timetable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );

  runApp(IndexPage());
}

class IndexPage extends StatefulWidget{

  String url;
  IndexPage({Key key, this.url}): super (key: key);

  @override
  _MyIndexPage createState() => _MyIndexPage(url);
}

class _MyIndexPage extends State<IndexPage>{

  String loadUrl;
  _MyIndexPage(this.loadUrl);

  String currentUrl;

  //String currentUrlByUser;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color logoGreen = Color(0xffD0752c);

  final User user = FirebaseAuth.instance.currentUser;

  DatabaseReference bookmarkRef = FirebaseDatabase.instance.reference().child("bookmarks").child(FirebaseAuth.instance.currentUser.uid);

  InAppWebViewController webView;


  createAddBookmarkAlertDialog (BuildContext context, String currentUrlByUserz){
    TextEditingController _controllerBookmarkTitle = TextEditingController();
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
            onPressed: () {

              if(_controllerBookmarkTitle.text.isEmpty){
                displayToastMessage("Title is required!", context);
              }else{
                String bookmarkTitle =  _controllerBookmarkTitle.text.toString();
                String bookmarkUrl = currentUrlByUserz;


                final uid = user.uid;

                Map bookmarkDetails = {
                  "bookmarkTitle": bookmarkTitle,
                  "bookmarkUrl": bookmarkUrl,
                };

                DatabaseReference bookmarkRef = FirebaseDatabase.instance.reference().child("bookmarks");
                bookmarkRef.child(uid).child(_randomString(20)).set(bookmarkDetails);
                // _controllerBookmarkTitle.clear();
                Navigator.of(context).pop();
              }


            },
          )
        ],
      );
    }
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(loadUrl == null){
      loadUrl = "https://courseweb.sliit.lk/my/";
    }else{
      if(loadUrl.startsWith("https://")){
        loadUrl=loadUrl;
      }else if(loadUrl.startsWith("http://")){
        loadUrl=loadUrl;
      }else if(!loadUrl.startsWith("https://")){
        loadUrl = "http://" + loadUrl;
      }else if(!loadUrl.startsWith("http://")){
        loadUrl = "http://" + loadUrl;
      }
    }
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: logoGreen,
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: () {
                webView.goBack();
              }),
              SizedBox(width: 10,),
              IconButton(icon: Icon(Icons.autorenew_outlined, color: Colors.white,), onPressed: () {
                webView.reload();
              }),
              Spacer(),
            IconButton(icon: Icon(Icons.arrow_forward_ios, color: Colors.white,), onPressed: () {
              webView.goForward();
              }),
            ],
          ),
        ),
        floatingActionButton:
        FloatingActionButton(
          backgroundColor: logoGreen,
          child: Icon(Icons.grid_view),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (_) => Timetable("zz")));
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>Timetable(clickedDay : null),
              ));


            },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          backgroundColor: logoGreen,
          title:  Text("AM SLIIT"),
          actions: [
            IconButton(
              icon: Icon(Icons.push_pin_rounded),
              onPressed: () async {

                String currentUrlz = await webView.getUrl();
                print(currentUrlz);

                createAddBookmarkAlertDialog(context, currentUrlz);



              } , // => function();
            ),
            IconButton(
              icon: Icon(Icons.collections_bookmark_sharp),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => Bookmark()));
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
                  webView.loadUrl(url :'https://courseweb.sliit.lk/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Student Portal'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'https://study.sliit.lk/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Eduscope'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'https://lecturecapture.sliit.lk/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Online Exams'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl( url: 'https://onlineexams.sliit.lk/login/index.php');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Net Exams'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'https://netexam.sliit.lk/login/index.php');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('sliit.lk'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'https://sliit.lk/l');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Student Profile'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'http://student.sliit.lk/profile/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Email/Domain Password Reset'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'http://study.sliit.lk:600/');
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Sign Out'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  signOutNow(context);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        endDrawer: Drawer(
          // Populate the Drawer in the next step.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text("Help to make things better!",
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
                title: Text('Send Suggestions'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'https://docs.google.com/forms/d/e/1FAIpQLSejG3xMPJ7HAATcBq0wIx9_bxpmePUlozpd7JCUflMwhHVmmw/viewform?usp=sf_link');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Bugs On Android'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url: 'https://docs.google.com/forms/d/e/1FAIpQLSe4irKNph5Duj5m2vgOlFaVW51sD70FMYY8KrpvO2hU-OiJ_g/viewform?usp=sf_link');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Bugs On Apple (IOS)'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl( url: 'https://docs.google.com/forms/d/e/1FAIpQLSeFlMZNzfRWawZ8jn1ofpvRvpUhmqsHmV3l_D2PEqqd4M_V9Q/viewform?usp=sf_link');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Comment Anonymously'),
                onTap: () {
                  // Update the state of the app
                  // ..
                  webView.loadUrl(url:'https://docs.google.com/forms/d/e/1FAIpQLSf_lvaC1MOXtQrqxe8V51Hy9MvdB1k_wjnhtcVOhGB6D45rww/viewform?usp=sf_link');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Contact Developer'),
                onTap: () {
                  // Update the state of the app
                  // ..

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
       body:
       Container(
           child: Column(children: <Widget>[
             Expanded(
                 child: InAppWebView(
                   initialUrl: loadUrl,
                   initialHeaders: {},
                   initialOptions: InAppWebViewGroupOptions(
                     crossPlatform: InAppWebViewOptions(
                         debuggingEnabled: true,
                         useOnDownloadStart: true
                     ),
                   ),
                   onWebViewCreated: (InAppWebViewController controller) {
                     webView = controller;
                   },
                   onLoadStart: (InAppWebViewController controller, String url) {
                     setState(() {
                       this.loadUrl = url;
                     });
                   },
                   onLoadStop: (InAppWebViewController controller, String url) {
                     setState(() {
                       this.loadUrl = url;
                     });
                   },
                   onDownloadStart: (controller, url) async {
                     final externalDir = await getExternalStorageDirectory();
                     final status = await Permission.storage.request();
                     if(status.isGranted){
                       print("onDownloadStart $url");
                       await FlutterDownloader.enqueue(
                         url: url,
                         savedDir: "/storage/emulated/0/Download/",
                         //savedDir: externalDir.path,
                         showNotification: true, // show download progress in status bar (for Android)
                         openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                       );
                     }else{
                       print('permission denied');
                     }

                   },
                 ))
           ])),


      ),
    );
  }


  void makeThisPageAsBookMark(BuildContext context, String bookmarkTitle, String bookmarkUrl) {

    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;

    Map bookmarkDetails = {
      "bookmarkTitle": bookmarkTitle,
      "bookmarkUrl": bookmarkUrl,
    };

    DatabaseReference bookmarkRef = FirebaseDatabase.instance.reference().child("bookmarks");
    bookmarkRef.child(uid).child(_randomString(20)).set(bookmarkDetails);

  }

  }



  loadLoggedUsersBookmarks(BuildContext context){

    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    DatabaseReference bookmarkRef = FirebaseDatabase.instance.reference().child("bookmarks");


    bookmarkRef.child(uid).once().then((DataSnapshot snapshot){
      if(snapshot.value.isNotEmpty){
          snapshot.value.forEach((key,values) {

            Map bookmarkDetails = {
              "bookmarkTitle": values["bookmarkTitle"],
              "bookmarkUrl": values["bookmarkUrl"],
            };

            print(bookmarkDetails);
          });

      }
    });


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
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  return getRandomString(length);

}

Future<void> signOutNow (BuildContext context) async {

  await FirebaseAuth.instance.signOut();
  Navigator.push(context,
      MaterialPageRoute(builder: (_) => LoadWelcomePage()));

}




displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg: message);
}
