import 'package:database_practice/models/record.dart';

//a set of records
class Cart {
  final cartBooks = Set<Record>();

  void addToCart(Record record) {
    //can add a record to the set
    cartBooks.add(record);
  }

  void removeFromCart(Record record) {
    //or remove it from the set
    cartBooks.remove(record);
  }
}
