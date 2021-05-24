// a checkout screen: this is where the user would pay for their books

import 'package:url_launcher/url_launcher.dart'; //use this package to take buyer to external url to pay

import 'package:flutter/material.dart';
import 'package:database_practice/models/cart.dart';
import 'package:database_practice/database.dart';
import 'buybook.dart';

const _url = 'https://flutter.dev';

class Checkout extends StatelessWidget {

  final Cart cart;
  List cartAsAList;
  List sellers; 

  Checkout({Key key, @required this.cart}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    double total = 0; 
    cartAsAList = cart.cartBooks.toList();

    //calculate the total
    for(var i = 0; i < cartAsAList.length; i++){
        total += cartAsAList[i].price;
    }


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
                  onPressed: () { 
                    notifySellers(cartAsAList); 
                    Navigator.pushNamed(context, '/home');
                  }
                )

              ]),
        ));
  }
}

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
    

notifySellers(List cartBooks) async {
  
  //loop through the cartbooks array and get the uid of all sellers
  //connect to users database
  //add a notification to the notification variable for each seller

}