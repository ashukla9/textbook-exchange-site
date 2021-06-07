//display the 'profile' of the student
//what classes they're taking, what grade they are, etc.
//edit profile functionality: have users add their payment urls

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_practice/models/record.dart';

//profile page
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  //VERY IMPORTANT! creates instance of Auth to get user information
  final FirebaseAuth auth = FirebaseAuth.instance;
  List _allResults = [];
  final currentUid = FirebaseAuth.instance.currentUser.uid;
  final currentName = FirebaseAuth.instance.currentUser
      .displayName; //added this variable so the user can see their username instead of a long string of numbers

  //add logic: if user is signed in, then display the page, but if theyre not signed in, ask to sign in/up

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: Center(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(children: [
                Text(
                  "Welcome, " + currentName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: CustomColors.lsMaroon),
                ),
                Text(
                    "This is your profile page. This is where you can view all your current listings and see when your books are added to someone's cart or checked out."),
                SizedBox(height: 20)
              ]),
            ),
            Text("Your Listings:"),
            SizedBox(height: 20),

            //displays currently active listings:
            DisplayBooks(),

            //edit profile button
            /*Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(currentUid),
                            ),
                          );
                        },
                        child: Text("Edit Profile"))),
              )*/
          ],
        )));
  }
}

//displays book list
class DisplayBooks extends StatefulWidget {
  @override
  _DisplayBooksState createState() {
    return _DisplayBooksState();
  }
}

class _DisplayBooksState extends State<DisplayBooks> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List _allResults = [];
  Future resultsLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getBookSnapshots();
  }

//only gets books that user has listed
  getBookSnapshots() async {
    var data = await database
        .collection('books')
        .where('lister', isEqualTo: auth.currentUser.uid)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    return "complete";
  }

  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: ListView.builder(
        itemCount: _allResults.length,
        itemBuilder: (BuildContext context, int index) =>
            _buildListItem(context, _allResults[index]),
      ),
    ));
  }
}

//build list of books that the user has listed
Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: record.status == "reserved"
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                title: Text(record.name),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      //delete permanently
                      await database
                          .collection("books")
                          .doc(record.doc_id)
                          .delete();
                    }),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                title: Text(record.name),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      //delete permanently
                      await database
                          .collection("books")
                          .doc(record.doc_id)
                          .delete();
                    }),
              ),
            ));
}

//Edit profile class, might be deleted
class EditProfile extends StatefulWidget {
  @override
  final String currentUid;
  EditProfile(this.currentUid);

  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _paymentUrlController = new TextEditingController();
    //imported from database.dart, properties
    _paymentUrlController.text = paymentUrl;

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: Column(children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Enter your new payment url(i.e. https://paypal.me/faketester):"),
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _paymentUrlController,
                    autofocus: true,
                  )),
              ElevatedButton(
                child: Text("Update"),
                onPressed: () async {
                  await database
                      .collection("users")
                      //the doc of the UID!
                      .doc(widget.currentUid)
                      //sets the paymentUrl field of the user
                      .set({
                    "paymentUrl": _paymentUrlController.text,
                  });

                  Navigator.of(context)
                      .pop(); //change this to go back to profile page
                },
              ),
            ],
          ))
        ]));
  }
}
