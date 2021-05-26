import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  // a class for the book listings, probably should rename to Listing
  final String name;
  final double price;
  final String author;
  final String user;
  final String username;
  final String condition;
  final bool status;
  //final String description;
  final DocumentReference reference;

  final String doc_id;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['author'] != null),
        assert(map['condition'] != null),
        assert(map['user'] != null),
        assert(map['status'] != null),
        name = map['name'],
        price = map['price'],
        author = map['author'],
        condition = map['condition'],
        user = map['user'],
        username = map['username'],
        status = map['status'],
        doc_id = reference
            .id; //https://stackoverflow.com/questions/58844095/how-to-get-firestore-document-id

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$name:$price:$author:$condition:$user:$username:$status:$doc_id>";
}
