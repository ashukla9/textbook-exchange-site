import 'package:flutter/material.dart';
import 'login.dart'; //gets the username variable
import 'package:database_practice/database.dart';

class SellBooks extends StatefulWidget {
  @override
  _SellBooksState createState() {
    return _SellBooksState();
  }
}

class _SellBooksState extends State<SellBooks> {
  @override
  Widget build(BuildContext context) {
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
                      //    "user": uid,
                      //somehow it's autopopulating the user field but I DON'T KNOW HOW LMAO
                    })
                    .then((value) =>
                        print("Textbook added")) // it's not doing this either
                    //if there is an error
                    .catchError(
                        (error) => print("Failed to add textbook")); //or this
                Navigator.of(context).popUntil((route) =>
                    route.isFirst); //change this to reset to blank form
              },
            ),
          ],
        )));
  }
}
