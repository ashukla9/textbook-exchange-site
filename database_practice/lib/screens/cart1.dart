import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:database_practice/database.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/models/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'checkout.dart';

//Once you close the app or log out, the cart should empty itself out

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
        body: displayBooks(context));
  }
}

//DISPLAYS BOOK LIST
Widget displayBooks(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  return StreamBuilder<QuerySnapshot>(
    stream: database
        .collection('books')
        .where('view status', isEqualTo: false)
        .where('buyer', isEqualTo: auth.currentUser.uid)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      // changed bc of Firebase documentation
      return _buildList(context, snapshot.data.docs);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

/*
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
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
                        builder: (context) => Checkout(cart: _allResults,),
                      )
                  );
                },
                child: Text("Checkout")
            ) 
          ]
        )
    );
  } */

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
                await database.collection("books").doc(record.doc_id).update({
                  "view status": true,
                  "buyer": "N/A",
                });
              }),
        ),
      ));
}
