// creates a class / model for a single user in the system
// will connect to google login information based on uid and auto fill the name field!

import 'package:cloud_firestore/cloud_firestore.dart';

class TbUser { // a class for the users
  final String name;
  final String paymentUrl;

  final DocumentReference reference;

  TbUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        //assert(map['paymentUrl'] != null),

        name = map['name'],
        paymentUrl = map['paymentUrl'];
        
  TbUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$paymentUrl>";
}
