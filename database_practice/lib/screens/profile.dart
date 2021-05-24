//display the 'profile' of the student
//what classes they're taking, what grade they are, etc.
//edit profile functionality: have users add their payment urls
//if we are to expand, then we would add 'recommended books' here.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/database.dart';

//right now this functions more as an "edit profile" page lol

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  @override

  //add logic: if user is signed in, then display the page, but if theyre not signed in, ask to sign in/up

  Widget build(BuildContext context) {
    //VERY IMPORTANT! creates instance of Auth to get user information
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUid = auth.currentUser.uid;
    final currentName = auth.currentUser.displayName; //added this variable so the user can see their username instead of a long string of numbers

    return Scaffold(
        appBar: AppBar(
            title: Text("Profile") //will change this once we switch everything around and put it on the right pages
            ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                  height: 20,
                ),
              Text("Welcome, " + currentName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30, 
                    color: CustomColors.lsMaroon),
              ),
              Text("Payment Url: ", //find a way to display payment url
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: CustomColors.lsMaroon),
              ),

              Text("Notifications: ",
                style: TextStyle( //find a way to display notifs
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: CustomColors.lsMaroon),
              ),


              Expanded(
                child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfile(currentUid),
                      ), //navigates to the details of the book page
                    );
                  },
                  child: Text("Edit Profile"))
              ),
              )
            ],
          )
        )
      );
  }
}

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
              Text("Enter your new payment url(i.e. https://paypal.me/faketester):" ),
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
