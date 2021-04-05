import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Record { // a class for the book listings, probably should rename to Listing
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


