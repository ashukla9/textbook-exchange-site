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
    _titleController.text = bookName;
    _priceController.text = price;

    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Sell Books") //will change this once we switch everything around and put it on the right pages
            ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //accepting input from user to list a textbook
            Text("Enter the name of your textbook"),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  //controller is basically 'variable', in this case titlecontroller is the private variable for the title
                  controller: _titleController,
                  autofocus: true,
                )),
            Text("Enter the price of your textbook"),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: _priceController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                )),
            ElevatedButton(
              child: Text("Submit"),
              onPressed: () async {
                await database
                    .collection("baby")
                    .doc(username)
                    .collection("books")
                    .doc(_titleController.text)
                    .set({
                      "name": _titleController.text,
                      "price": (int.parse(_priceController.text)),
                    })
                    .then((value) => print("Textbook added"))
                    //if there is an error
                    .catchError((error) => print("Failed to add textbook"));
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ));
  }
}
