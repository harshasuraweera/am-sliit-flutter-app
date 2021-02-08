import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditBookmark extends StatefulWidget {
  String contactKey;

  EditBookmark({this.contactKey});

  @override
  _EditBookmarkState createState() => _EditBookmarkState();
}

class _EditBookmarkState extends State<EditBookmark> {
  TextEditingController _titleController, _urlController;


  DatabaseReference _ref;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _urlController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('bookmarks').child(FirebaseAuth.instance.currentUser.uid);
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
        title: Text('Update Bookmark'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Center(
              child: Image.asset(
                'assets/edit_pic1.png',
                height: 200,
              ),
            ),
            SizedBox(height: 35),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                prefixIcon: Icon(
                  Icons.title,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'URL',
                prefixIcon: Icon(
                  Icons.link,
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
              height: 25,
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

    _titleController.text = contact['bookmarkTitle'];

    _urlController.text = contact['bookmarkUrl'];

  }

  void saveContact() {
    String title = _titleController.text.trim();
    String url = _urlController.text.trim();

    if(_titleController.text.isEmpty || _urlController.text.isEmpty){
      displayToastMessage("All the fields are mandatory", context);
    }else{
      Map<String, String> contact = {
        'bookmarkTitle': title,
        'bookmarkUrl':  url,
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
