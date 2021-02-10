import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBookmark extends StatefulWidget {
  @override
  _AddBookmarkState createState() => _AddBookmarkState();
}

class _AddBookmarkState extends State<AddBookmark> {
  TextEditingController _newTitleController, _newUrlController;

DatabaseReference _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _newTitleController = TextEditingController();
    _newUrlController = TextEditingController();
    _ref = FirebaseDatabase.instance.reference().child('bookmarks').child(FirebaseAuth.instance.currentUser.uid);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Custom Bookmark'),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35),
            Center(
              child: Image.asset(
                'assets/bookmark_1.png',
                height: 200,
              ),
            ),SizedBox(height: 55),
            TextFormField(
              controller: _newTitleController,
              decoration: InputDecoration(
                hintText: 'Enter Title',
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
              controller: _newUrlController,
              decoration: InputDecoration(
                hintText: 'Enter Url',
                prefixIcon: Icon(
                  Icons.link,
                  size: 30,
                ),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
           SizedBox(height: 15,),
           SizedBox(height: 25,),
           Container(
             width: double.infinity,
             padding: EdgeInsets.symmetric(horizontal: 10),
             // ignore: deprecated_member_use
             child: RaisedButton(child: Text('Add Now',style: TextStyle(
               fontSize: 20,
               color: Colors.white,
               fontWeight: FontWeight.w600,

             ),),
             onPressed: (){
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
  void saveContact(){

    String title = _newTitleController.text;
    String url = _newUrlController.text;

    if(_newUrlController.text.isEmpty || _newTitleController.text.isEmpty){
      displayToastMessage("All the fields are mandatory", context);
    }else{
      Map<String,String> contact = {
        'bookmarkTitle':title,
        'bookmarkUrl': url,
      };

      _ref.push().set(contact).then((value) {
        Navigator.pop(context);
      });
    }




  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }

}
