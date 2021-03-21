import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BuyBooks extends StatefulWidget {
  @override
  _BuyBooksState createState() {
    return _BuyBooksState();
  }
}

String bookName;
String price;

class _BuyBooksState extends State<BuyBooks> {
  final database = FirebaseFirestore.instance;
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
            Text("Enter the name of your book"),
            Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  controller: _titleController,
                  autofocus: true,
                )),
            Text("Enter the price of your book"),
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
                    .add({
                      "name": _titleController.text,
                      "votes": (int.parse(_priceController.text)),
                    })
                    .then((value) => print("User added"))
                    .catchError((error) => print("Failed to add user"));
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ));
  }
}
