import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTimetable extends StatefulWidget {
  @override
  _AddTimetableState createState() => _AddTimetableState();
}

class _AddTimetableState extends State<AddTimetable> {
  TextEditingController _moduleNameController, _venueController;
  String _typeSelected ='';

  TimeOfDay _timeOfDay_startTime = TimeOfDay.now();
  TimeOfDay startTime;

  TimeOfDay _timeOfDay_EndTime = TimeOfDay.now();
  TimeOfDay endTime;

  Future<Null> selectStartTime(BuildContext context) async{
    startTime = await showTimePicker(
        context: context,
        initialTime: _timeOfDay_startTime,
    );

    setState(() {
      _timeOfDay_startTime = startTime;
      print(_timeOfDay_startTime);
    });
  }

  Future<Null> selectEndTime(BuildContext context) async{
    endTime = await showTimePicker(
      context: context,
      initialTime: _timeOfDay_EndTime,
    );

    setState(() {
      _timeOfDay_EndTime = endTime;
      print(_timeOfDay_EndTime);
    });
  }



DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _moduleNameController = TextEditingController();
    _venueController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('timetables').child(FirebaseAuth.instance.currentUser.uid);
  }


Widget _buildContactType(String title){

  return InkWell(

    child: Container(
      height: 40,
      width: 90,

      decoration: BoxDecoration(
        color: _typeSelected == title? Colors.green : Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Center(child: Text(title, style: TextStyle(fontSize: 18,
      color: Colors.white),
    ),),),

    onTap: (){
      setState(() {
        _typeSelected = title;
      });
    },
  );
}

  String dayChoose;
  List daysListItem = [
    "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
  ];
  String typeChoose;
  List typeListItem = [
    "Lecture", "Tutorial", "Practical",
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
      Scaffold(
      appBar: AppBar(
        title: Text('Add Timetable Slot'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35),
            DropdownButton(
              isExpanded: true,
              hint: Text("Select day"),
              value: dayChoose,
              onChanged: (newValue){
                setState(() {
                  dayChoose = newValue;
                });
              },
              items: daysListItem.map((valueItem2) {
                return DropdownMenuItem(
                  value: valueItem2,
                  child: Text(valueItem2),
                );
              }).toList(),
            ),
            SizedBox(height: 15),
            DropdownButton(
              isExpanded: true,
              hint: Text("Select type"),
              value: typeChoose,
              onChanged: (newValue){
                setState(() {
                  typeChoose = newValue;
                });
              },
              items: typeListItem.map((valueItem1) {
                return DropdownMenuItem(
                  value: valueItem1,
                  child: Text(valueItem1),
                );
              }).toList(),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _moduleNameController,
              decoration: InputDecoration(
                hintText: 'Module Name/Code',
                prefixIcon: Icon(
                  Icons.menu_book_rounded,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _venueController,
              decoration: InputDecoration(
                hintText: 'Venue',
                prefixIcon: Icon(
                  Icons.place,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 25),
            Text("Starting Time"),
            IconButton(
               icon: Icon(
                 Icons.timer_rounded,
               ),
               onPressed: (){
                 selectStartTime(context);
                 print(startTime);
               },
           ),

           SizedBox(height: 25,),

            Text("Ending Time"),
            IconButton(
              icon: Icon(
                Icons.timer_rounded,
              ),
              onPressed: (){
                selectEndTime(context);
                print(endTime);
              },
            ),

           SizedBox(height: 25,),
           Container(
             width: double.infinity,
             padding: EdgeInsets.symmetric(horizontal: 10),
             child: RaisedButton(child: Text('Add Slot',style: TextStyle(
               fontSize: 20,
               color: Colors.white,
               fontWeight: FontWeight.w600,

             ),),
             onPressed: (){
               saveContact(dayChoose, typeChoose, formatTimeOfDay(_timeOfDay_startTime), formatTimeOfDay(_timeOfDay_EndTime), context);
             },

             color: Theme.of(context).primaryColor,
             ),
           )

          ],
        ),
      ),
    )
    );
  }
  void saveContact(String day, String type, String startingTime, String endingTine, BuildContext context){


    String moduleName = _moduleNameController.text.trim();
    String venue = _venueController.text.trim();

    String typeChoose = type;
    String dayChoose = day;
    String choosedStartingTime = startingTime;
    String choosedEndingTime = endingTine;

    Map<String,String> contact = {
      'moduleName':moduleName,
      'venue':  venue,
      'type': typeChoose,
      'day': dayChoose,
      'startingTime': choosedStartingTime,
      'endingTime': choosedEndingTime,
    };

    _ref.child(day).push().set(contact).then((value) {
      Navigator.pop(context);
    });


  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();  //"6:00 AM"
    return format.format(dt);
  }


}














