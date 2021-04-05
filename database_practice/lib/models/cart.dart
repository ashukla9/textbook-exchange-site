import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:database_practice/models/record.dart';

// a cart is just a bunch of records, so do we need this..? 

class Cart{
  final cartBooks = Set<Record>();

  void addToCart(Record record){
    cartBooks.add(record);
  }

  void removeFromCart(Record record){
    cartBooks.remove(record);
  }
}