import 'package:cloud_firestore/cloud_firestore.dart';

class Record { // a class for the book listings, probably should rename to Listing
  final String name;
  final double price;
  final String author;
  final String user;
  //final String description;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['author'] != null),
        assert(map['user'] != null),

        name = map['name'],
        price = map['price'],
        author = map['author'],
        user = map['user'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$price:$author:$user>";
}


