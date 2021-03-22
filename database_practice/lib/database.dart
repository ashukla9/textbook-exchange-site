//the controller file for the database.

//currently only creates a new database 'instance' 

//avoids confusion-- there is only ONE instance in THIS file, and the other screens IMPORT this file
// to use this one instance

import 'package:cloud_firestore/cloud_firestore.dart';

String bookName;
String price;

final database = FirebaseFirestore.instance;