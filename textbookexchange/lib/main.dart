import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'screens/random_words.dart'; //importing the random words file from the screens folder
import 'screens/home.dart'; //importing the home screen
import 'package:textbookexchange/routes.dart'; //importing the routes

void main() => runApp(MyApp()); //main method runs "MyApp"
//MyApp is "core" or "root" widget

class MyApp extends StatelessWidget {
  //immutable widget, stateless
  @override
  Widget build(BuildContext context) {
    // [NO LONGER USED] final wordPair = WordPair.random(); //final=const in js, can't directly reassign the variable. Can use const if value of var is always known.

    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
          primaryColor:
              Colors.purple[50]), //change theme color and appbar color

      initialRoute: "/",
      routes:
          routes, //routes is the Map we have in routes.dart [source: https://morioh.com/p/99b14cbf048e]
    );
  }
}
