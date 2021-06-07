// creates a class / model for a single user in the system
import 'package:cloud_firestore/cloud_firestore.dart';

class TbUser { // a class for the users
  final String name;
  final String email;
  final String paymentUrl;

  final DocumentReference reference;

  final String doc_id;


  TbUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['email'] != null),
        //assert(map['paymentUrl'] != null),
        
        name = map['name'],
        email = map['email'],
        paymentUrl = map['paymentUrl'],

        doc_id = reference
            .id; //used this to get the document id: https://stackoverflow.com/questions/58844095/how-to-get-firestore-document-id

        
        
  TbUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$email:$paymentUrl:$doc_id>";

}
