import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditTimetable extends StatefulWidget {

  String contactKey, clickedDay;
  EditTimetable({Key key, this.contactKey, this.clickedDay}): super (key: key);


  @override
  _EditTimetableState createState() => _EditTimetableState(clickedDay);
}

class _EditTimetableState extends State<EditTimetable> {

  String clickedDay;
  _EditTimetableState(this.clickedDay);


  TextEditingController _moduleController, _venueController, _typeController, _startingTimeController, _endingTimeController;


  DatabaseReference _ref;
  @override
  void initState() {
    super.initState();
    _moduleController = TextEditingController();
    _venueController = TextEditingController();
    _typeController = TextEditingController();
    _startingTimeController = TextEditingController();
    _endingTimeController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('timetables').child(FirebaseAuth.instance.currentUser.uid).child(clickedDay);
    getContactDetail();
  }

  Widget _buildContactType(String title) {
    return InkWell(
      child: Container(
        height: 40,
        width: 90,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {

        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Timetable Slot'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 45),
            TextFormField(
              controller: _moduleController,
              decoration: InputDecoration(
                hintText: 'Module Name',
                prefixIcon: Icon(
                  Icons.menu_book,
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
            SizedBox(height: 15),
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(
                hintText: 'Type',
                prefixIcon: Icon(
                  Icons.wb_sunny_sharp,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _startingTimeController,
              decoration: InputDecoration(
                hintText: 'Starting Time',
                prefixIcon: Icon(
                  Icons.play_circle_filled_sharp,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _endingTimeController,
              decoration: InputDecoration(
                hintText: 'Ending Time',
                prefixIcon: Icon(
                  Icons.stop_circle_outlined,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: RaisedButton(
                child: Text(
                  'Update Contact',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  saveContact();
                },
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  getContactDetail() async {
    DataSnapshot snapshot = await _ref.child(widget.contactKey).once();

    Map contact = snapshot.value;

    _moduleController.text = contact['moduleName'];
    _venueController.text = contact['venue'];
    _typeController.text = contact['type'];
    _startingTimeController.text = contact['startingTime'];
    _endingTimeController.text = contact['endingTime'];

  }

  void saveContact() {

    String moduleName = _moduleController.text.trim();
    String venue = _venueController.text.trim();
    String startingTime = _startingTimeController.text.trim();
    String endingTime = _endingTimeController.text.trim();
    String type = _typeController.text.trim();

    if(_moduleController.text.isEmpty || _venueController.text.isEmpty || _startingTimeController.text.isEmpty || _endingTimeController.text.isEmpty || _typeController.text.isEmpty){
      displayToastMessage("All the fields are mandatory", context);

    }else if(_startingTimeController.text.endsWith("AM") || _startingTimeController.text.endsWith("PM") || _endingTimeController.text.endsWith("AM") || _endingTimeController.text.endsWith("PM")){
      displayToastMessage("Please consider about AM & PM", context);
    }else{
      Map<String, String> contact = {
        'moduleName': moduleName,
        'venue':  venue,
        'startingTime':  startingTime,
        'endingTime':  endingTime,
        'type':  type,
      };

      _ref.child(widget.contactKey).update(contact).then((value) {
        Navigator.pop(context);
      });
    }


  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }

}
