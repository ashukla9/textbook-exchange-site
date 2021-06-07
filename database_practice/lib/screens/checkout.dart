// a checkout screen: this is where the user would pay for their books

import 'package:url_launcher/url_launcher.dart'; //use this package to take buyer to external url to pay
import 'package:database_practice/models/record.dart';
import 'package:flutter/material.dart';
import 'package:database_practice/models/cart.dart';
import 'package:database_practice/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _url = 'https://flutter.dev';

//checkout page for people to officially buy books
class Checkout extends StatelessWidget {
  final List cart;
  List sellers;

  Checkout({Key key, @required this.cart}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double total = 0;
    String totalString = "";
    //cartAsAList = cart.toList();

    //calculate the total
    for (var i = 0; i < cart.length; i++) {
      total += cart[i].get('price');
    }

    totalString = total.toStringAsFixed(2);

    return Scaffold(
        appBar: AppBar(
          title: Text("Checkout"),
        ),
        body: Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Your total is: \$" + totalString,
                      style: TextStyle(fontSize: 30),
                    ), //convert total to a string

                    SizedBox(height: 20), //adding space between widgets

                    Text(
                        "Once you confirm your purchase / reservation, the sellers will be in contact with you with more details on how to pay."), //convert total to a string

                    SizedBox(height: 20),

                    ElevatedButton(
                        child: Text("Reserve Books"),
                        onPressed: () async {
                          for (var i = 0; i < cart.length; i++) {
                            deletefromcart(cart[i]);
                          }
                          Navigator.pushNamed(context, '/home');
                        })
                  ]),
            )));
  }
}

//delete books from cart + move them back to marketplace
deletefromcart(DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  database.collection("books").doc(record.doc_id).update({
    "view status": "reserved",
  });
}
