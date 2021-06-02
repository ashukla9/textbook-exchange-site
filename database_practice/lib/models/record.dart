import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  // a class for the book listings, probably should rename to Listing
  final String name;
  final double price;
  final String author;
  final String user; //seller uid
  final String username; //seller display name
  final String condition;
  final bool status;
  final int numberOfOffers;
  final String buyer;
  //final String description;
  final DocumentReference reference;

  final String doc_id;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        price = map['price'],
        author = map['author'],
        condition = map['condition'],
        user = map['lister'],
        username = map['lister username'],
        status = map['view status'],
        numberOfOffers = map['numberOfOffers'],
        buyer = map['buyer'],
        doc_id = reference
            .id; //https://stackoverflow.com/questions/58844095/how-to-get-firestore-document-id

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$name:$price:$author:$condition:$user:$username:$status:$numberOfOffers:$doc_id>";
}
