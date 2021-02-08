import 'dart:math';

import 'package:am_sliit/bookmark_screens/bookmarks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:am_sliit/index.dart';
import 'add_timetable.dart';
import 'edit_timetable.dart';
import 'package:intl/date_symbol_data_local.dart';

class Timetable extends StatefulWidget {

  String clickedDay;
  Timetable({Key key, this.clickedDay}): super (key: key);


  @override
  _TimetableState createState() => _TimetableState(clickedDay);
}

class _TimetableState extends State<Timetable> {


  String clickedDay;
  _TimetableState(this.clickedDay);
  
  String today = DateFormat('EEEE').format(DateTime.now());
  Query _ref;
  DatabaseReference reference =
      FirebaseDatabase.instance.reference().child('timetables').child(FirebaseAuth.instance.currentUser.uid);

  String dayChoose;
  List daysListItem = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];


  String _selectedDateFromRightTopMenu;



  @override
  void initState() {
    String loadingDay;

    if(clickedDay == null){
      loadingDay = today;
    }else if(clickedDay != null){
      loadingDay = clickedDay;
    }

    super.initState();
    _ref = FirebaseDatabase.instance
        .reference().child('timetables')
        .child(FirebaseAuth.instance.currentUser.uid).child(loadingDay);
  }

  Widget _buildContactItem({Map contact}) {



    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text( "Module Name : " +
                contact['moduleName'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.place,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text("Venue : "+
                contact['venue'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 15),

            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.wb_sunny_sharp,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text( "Type : " +
                  contact['type'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.play_circle_filled_sharp,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text( "Starting at : " +
                  contact['startingTime'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.stop_circle_outlined,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text( "Ending at : " +
                  contact['endingTime'],
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),


          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  String loadingDay;
                  if(clickedDay == null){
                    loadingDay = today;
                  }else if(clickedDay != null){
                    loadingDay = clickedDay;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditTimetable(
                                contactKey: contact['key'],
                                clickedDay: loadingDay,
                              )));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Edit',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showDeleteDialog(contact: contact);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text('Delete',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  _showDeleteDialog({Map contact}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete ${contact['moduleName']}'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')),
              FlatButton(
                  onPressed: () {

                    String loadingDay;

                    if(clickedDay == null){
                      loadingDay = today;
                    }else if(clickedDay != null){
                      loadingDay = clickedDay;
                    }

                    reference
                        .child(loadingDay)
                        .child(contact['key'])
                        .remove()
                        .whenComplete(() => Navigator.pop(context));
                  },
                  child: Text('Delete'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    String loadingDay;

    if(clickedDay == null){
      loadingDay = today;
    }else if(clickedDay != null){
      loadingDay = clickedDay;
    }


    return SafeArea(
      child: Scaffold(
      appBar: AppBar(
        title: Text(loadingDay + " Timetable"),
        actions: <Widget> [
          PopupMenuButton(
              onSelected: (String str){
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>Timetable(clickedDay : str),
                  ));
                 
                });
              },
              itemBuilder: (BuildContext context){
            return <PopupMenuEntry<String>>[
              PopupMenuItem(child: Text("Monday"), value: "Monday",),
              PopupMenuItem(child: Text("Tuesday"), value: "Tuesday",),
              PopupMenuItem(child: Text("Wednesday"), value: "Wednesday",),
              PopupMenuItem(child: Text("Thursday"), value: "Thursday",),
              PopupMenuItem(child: Text("Friday"), value: "Friday",),
              PopupMenuItem(child: Text("Saturday"), value: "Saturday",),
              PopupMenuItem(child: Text("Sunday"), value: "Sunday",),
            ];
          })
        ],
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            contact['key'] = snapshot.key;
            return _buildContactItem(contact: contact);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return AddTimetable();

            }),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    )
    );
  }


  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }

  String getDay(BuildContext context){
    var date = DateTime.now();
    return DateFormat('EEEE').format(date);
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

  void choiseAction(String choice){
    print("working");
  }


}
