import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:database_practice/models/tbuser.dart';
import 'package:database_practice/database.dart';


//the LOGIN page

class Login extends StatefulWidget {
  @override
  _LoginState createState() {
    return _LoginState();
  }
}

User _user; //changed based on updated documentation
String username;
String uid;

class _LoginState extends State<Login> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = new GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Google Authentication'),
        ),
        body: isSignIn
            ? Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user.photoURL),
                    ),
                    Text(_user.displayName),
                    OutlinedButton(
                      onPressed: () {
                        googleSignOut();
                      },
                      child: Text("Logout"),
                    )
                  ],
                ),
              )
            : Center(
                child: OutlinedButton(
                  onPressed: () {
                    handleSignIn();
                  },
                  child: Text("Sign In with Google"),
                ),
              ));
  }

  bool isSignIn = false;

  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

//changed based on updated documentation
    GoogleAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

//changed based on updated documentation
    UserCredential result = (await _auth.signInWithCredential(credential));

    _user = result.user;
    username = _user.displayName;
    uid = _user.uid;

    setState(() {
      isSignIn = true;
    });
  }

  Future<void> googleSignOut() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut;
      setState(() {
        isSignIn = false;
      });
    });

  }
}
