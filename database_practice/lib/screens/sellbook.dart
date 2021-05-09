import 'package:flutter/material.dart';
import 'login.dart'; //gets the username variable
import 'package:database_practice/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellBooks extends StatefulWidget {
  @override
  _SellBooksState createState() {
    return _SellBooksState();
  }
}

class _SellBooksState extends State<SellBooks> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _price, _author, _error;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Sell Books") //will change this once we switch everything around and put it on the right pages
            ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    hintText: "Textbook name",
                  ),
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please input textbook name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value,
                ),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please input textbook price';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    hintText: "Textbook price",
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => _price = value,
                ),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Please input textbook author';
                    }
                    return null;
                  },
                  style: TextStyle(
                    fontSize: 22,
                  ),
                  decoration: InputDecoration(
                    hintText: "Textbook author",
                  ),
                  onSaved: (value) => _author = value,
                ),
                ElevatedButton(
                    child: Text("Submit"),
                    onPressed: () async {
                      if (validate()) {
                        try {
                          await database
                              .collection("books")
                              .doc(_name)
                              .set({
                                "name": _name,
                                "price": double.parse(_price),
                                "author": _author,
                                "user": auth.currentUser
                                    .displayName, // changed to show the UID --> might need to change to name
                              })
                              .then((value) => print("Textbook added"))
                              //if there is an error
                              .catchError((error) =>
                                  print("Failed to add textbook")); //or this
                          Navigator.of(context).popUntil((route) => route
                              .isFirst); //change this to reset to blank form
                        } catch (e) {
                          setState(() {
                            _error = e.message;
                          });
                        }
                      }
                    }),
              ],
            ))));
  }
}
