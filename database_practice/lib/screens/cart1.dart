import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:database_practice/database.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/models/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'checkout.dart';

//cart where people can see books they've saved
class Cart1 extends StatefulWidget {
  @override
  _Cart1State createState() {
    return _Cart1State();
  }
}

class _Cart1State extends State<Cart1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: DisplayBooks(),
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: CustomColors.lsMaroon,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              title: Text('Cart'),
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              title: Text('Marketplace'),
              onTap: () {
                Navigator.pushNamed(context, '/buyBooks');
              },
            ),
            ListTile(
              title: Text('Sell A Book'),
              onTap: () {
                Navigator.pushNamed(context, '/sellBooks');
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}

//displays book list
class DisplayBooks extends StatefulWidget {
  @override
  _DisplayBooksState createState() {
    return _DisplayBooksState();
  }
}

class _DisplayBooksState extends State<DisplayBooks> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List _allResults = [];
  Future resultsLoaded;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getBookSnapshots();
  }

//only gets books in user's cart
  getBookSnapshots() async {
    var data = await database
        .collection('books')
        .where('view status', isEqualTo: "cart")
        .where('buyer', isEqualTo: auth.currentUser.uid)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    return "complete";
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      if (_allResults.length != 0) //if there are books in the cart...
        Countdown(
          //use a timer so that books don't sit in a user's cart indefinitely and then aren't able to be displayed in marketplace
          duration: Duration(minutes: 25),
          onFinish: () async {
            //when it's finished, the items are deleted from the cart and visible in the marketplace again
            for (var i = 0; i < _allResults.length; i++) {
              deletefromcart(_allResults[i]);
            }
            await Future.delayed(Duration(seconds: 1));
            Navigator.pushReplacementNamed(context, '/buyBooks');
          },
          builder: (BuildContext ctx, Duration remaining) {
            return Text('');
          },
        ),
      Expanded(
        child: ListView.builder(
          itemCount: _allResults.length,
          itemBuilder: (BuildContext context, int index) =>
              _buildListItem(context, _allResults[index]),
        ),
      ),
      ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Checkout(cart: _allResults), //goes to checkout
                ));
          },
          child: Text("Checkout")),
    ]));
  }

//delete books from cart + move them back to marketplace
  deletefromcart(DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    database.collection("books").doc(record.doc_id).update({
      "view status": "marketplace",
      "buyer": "N/A",
    });
  }
}

//build list of books in cart
Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                //if deleted, move back to marketplace
                await database.collection("books").doc(record.doc_id).update({
                  "view status": "marketplace",
                  "buyer": "N/A",
                });
                Navigator.of(context).pushReplacementNamed('/cart');
              }),
        ),
      ));
}
