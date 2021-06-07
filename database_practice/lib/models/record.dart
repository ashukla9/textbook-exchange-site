import 'package:cloud_firestore/cloud_firestore.dart';

// a class for the book listings
class Record {
  final String name;
  final double price;
  final String author;
  final String user; //seller uid
  final String username; //seller display name
  final String condition;
  final String status;
  final String buyeremail;
  final String buyer;
  final DocumentReference reference;

  final String doc_id;

//gets the values from the database + add them to the record
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map['name'],
        price = map['price'],
        author = map['author'],
        condition = map['condition'],
        user = map['lister'],
        username = map['lister username'],
        status = map['view status'],
        buyeremail = map['buyer email'],
        buyer = map['buyer'],
        doc_id = reference
            .id; //used this to get the document id: https://stackoverflow.com/questions/58844095/how-to-get-firestore-document-id

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$name:$price:$author:$condition:$user:$username:$status:$buyer:$buyeremail:$doc_id>";
}
