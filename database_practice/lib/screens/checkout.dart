// a checkout screen: this is where the user would pay for their books

import 'package:url_launcher/url_launcher.dart'; //use this package to take buyer to external url to pay
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:database_practice/models/cart.dart';
import 'package:database_practice/models/tbuser.dart';
import 'package:database_practice/database.dart';
import 'buybook.dart';

const _url = 'https://flutter.dev';

class Checkout extends StatelessWidget {

  final Cart cart;
  List cartAsAList;
  //create a growable String type list of sellers
  List<String> sellers = <String>[]; 
  
  Checkout({Key key, @required this.cart}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    double total = 0; 
    cartAsAList = cart.cartBooks.toList();

    //calculate the total
    for(var i = 0; i < cartAsAList.length; i++){
        total += cartAsAList[i].price;
        //also add all sellers to a list
        //add logic to check if seller is already on the list
        sellers.add(cartAsAList[i].user);
    }

    //build the notification list
    

    return Scaffold(

        appBar: AppBar(
            title: Text(
                "Sell Books") //will change this once we switch everything around and put it on the right pages
            ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text("Your total is: " + total.toString()), //convert total to a string

                SizedBox(height: 20), //adding space between widgets

                Text("Once you confirm your purchase / reservation, the sellers will be in contact with you with more details on how to pay."), //convert total to a string

                ElevatedButton(
                  child: Text("Reserve Books"),
                  onPressed: () async { 
                    for (int i = 0; i < sellers.length; i++) {
                      //List<String> newNotifications = sellers[i].getNotifications();
                      await database
                        .collection("users")
                        .doc(sellers[i])
                          //.get(notifications) = var a 
                          .set({
                            "notifications": /*add a notif here...*/ "test",
                          });
                    Navigator.pushNamed(context, '/home');
                    }
                  }
                )

              ]),
        ));
  }
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
    
