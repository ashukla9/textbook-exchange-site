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
                child: Column(
                  children: [
                    Text(
                      "Welcome, " + currentName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: CustomColors.lsMaroon),
                    ),
                    Text("This is your profile page. This is where you can view all your current listings and see when your books are added to someone's cart or checked out."),
                    SizedBox(height: 20)
                  ]
                ),
              ), 
              Text("Current Listings:"), 
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
          )
        )
    );
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
        .where('view status', isEqualTo: "marketplace")
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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await database.collection("books").doc(record.doc_id).delete();
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
/*

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key key, User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  User _user;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.lsMaroon,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.lsMaroon,
    
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                      child: Material(
                        color: CustomColors.lsMaroon.withOpacity(0.3),
                        child: Image.network(
                          _user.photoURL,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Material(
                        color: CustomColors.lsMaroon.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: CustomColors.lsMaroon,
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 16.0),
              Text(
                'Hello',
                style: TextStyle(
                  color: CustomColors.lsMaroon,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _user.displayName,
                style: TextStyle(
                  color: CustomColors.lsMaroon,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '( ${_user.email} )',
                style: TextStyle(
                  color: CustomColors.lsMaroon,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
                style: TextStyle(
                    color: CustomColors.lsMaroon.withOpacity(0.8),
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}*/
