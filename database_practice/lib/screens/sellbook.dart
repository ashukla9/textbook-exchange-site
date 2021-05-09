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
                    await database
                        .collection("books")
                        .doc(_name)
                        .set({
                          "name": _name,
                          "price": double.parse(_price),
                          "author": _author,
                          "user":
                              uid, // changed to show the UID --> might need to change to name
                        })
                        .then((value) => print("Textbook added"))
                        //if there is an error
                        .catchError((error) =>
                            print("Failed to add textbook")); //or this
                    Navigator.of(context).popUntil((route) =>
                        route.isFirst); //change this to reset to blank form
                  },
                ),
              ],
            ))));
  }
}
/*
class _SellBooksState extends State<SellBooks> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    TextEditingController _titleController = new TextEditingController();
    TextEditingController _priceController = new TextEditingController();
    TextEditingController _authorController = new TextEditingController();

    //imported from database.dart, basic properties of a book
    _titleController.text = bookName;
    _priceController.text = price;
    _authorController.text = author;

    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Sell Books") //will change this once we switch everything around and put it on the right pages
            ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //accepting input from user to list a textbook
            Text("Enter the name of your textbook:"),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  //controller is basically 'variable', in this case titlecontroller is the private variable for the title
                  controller: _titleController,
                  autofocus: true,
                )),
            Text("Enter the price of your textbook:"),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: _priceController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                )),
            Text("Enter the author of your textbook:"),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: _authorController,
                  autofocus: true,
                )),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                await database
                    .collection("books")
                    .doc(_titleController.text)
                    .set({
                      "name": _titleController.text,
                      "price": (double.parse(_priceController.text)),
                      "author": _authorController.text,
<<<<<<< HEAD
                      "user": uid, // changed to show the UID --> might need to change to name
=======
                      "user": auth.currentUser.uid,
                      "username": auth.currentUser.displayName
>>>>>>> 90a25d2c31b4931106d01cd2342ebc87dda8c5e9
                    })
                    
                    .then((value) =>
                        print("Textbook added"))
                    //if there is an error
                    .catchError(
                        (error) => print("Failed to add textbook")); //or this

                Navigator.of(context).pushReplacementNamed('/sellBooks');
              },
            ),
          ],
        )));
  }
} */
