import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:database_practice/database.dart';
import 'package:database_practice/static/colors.dart';

class BuyBooks extends StatefulWidget {
  @override
  _BuyBooksState createState() {
    return _BuyBooksState();
  }
}

class _BuyBooksState extends State<BuyBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy Books')),
      body: ListPage(),
    );
  }
}

//create a 'page' that displays the list of books
// ListPage = DisplayBooks
class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // changed bc of Firebase documentation
      stream: FirebaseFirestore.instance.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        // changed bc of Firebase documentation
        return _buildList(context, snapshot.data.docs);
      },
    );
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

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
            trailing: Text(record.price.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(listing: record),
                ), //navigates to the details of the book page
              );
            }),
      ));
}

class Record {
  // a class for the book listings, probably should rename to Listing
  final String name;
  final double price;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        name = map['name'],
        price = map['price'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$price>";
}

//create a 'page' that displays the details of a book when you click on it
// DetailPage = BookDetails
//THIS DOES NOT WORK RN SOB
class DetailPage extends StatefulWidget {
  final Record listing;

  DetailPage({Key key, @required this.listing}) : super(key: key);
  //const DetailPage ({ Key key, this.listing }): super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      elevation: 10,
      shadowColor: Colors.amber[100],
      child: SizedBox(
        width: 350,
        height: 530,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Align(alignment: Alignment.centerRight, child: CloseButton()),

              CircleAvatar(
                //will put the image that user uploads in here!!
                backgroundColor: CustomColors.lsMaroon,
                radius: 90,
              ),
              SizedBox(
                height: 20,
              ), //SizedBox
              Text(
                widget.listing.name,
                style: TextStyle(
                  fontSize: 30,
                  color: CustomColors.lsMaroon,
                  fontWeight: FontWeight.w500,
                ), //Textstyle
              ), //Text
              Text(
                "\$" + widget.listing.price.toString(),
                style: TextStyle(
                  fontSize: 15,
                  color: CustomColors.lsMaroon,
                  fontWeight: FontWeight.w500,
                ), //Textstyle
              ), //Text
              SizedBox(
                height: 20,
              ), //SizedBox
              Text(
                "Insert description of book. I.e what class it is used in (like what subject), what the quality is, who the seller is (contact information), etc. Whatever else we put in the database.",

                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ), //Textstyle
              ), //Text
              SizedBox(
                height: 20,
              ), //SizedBox
              ElevatedButton(
                  onPressed: () => null,
                  //eventually implement this buy button
                  child: Text("Buy")),
            ],
          ),
        ),
      ),
    ));
  }
}
