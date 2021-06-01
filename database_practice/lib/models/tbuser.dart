// creates a class / model for a single user in the system
import 'package:cloud_firestore/cloud_firestore.dart';

class TbUser { // a class for the users
  final String name;
  final String paymentUrl;
  final List notifications;

  final DocumentReference reference;

  TbUser.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        //assert(map['paymentUrl'] != null),
        
        name = map['name'],
        paymentUrl = map['paymentUrl'],
        notifications = map['notifications'];
        
  TbUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$paymentUrl:$notifications>";

  //not necessary i think 
  List getNotifications() {
    return notifications;
  }
}
