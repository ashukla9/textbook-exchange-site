import 'package:flutter/widgets.dart';
import 'screens/home.dart';
import 'screens/random_words.dart';
 
 //organizes all the routes (which 'urls' link to which page)

 final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{ //later add these routes to routes.dart
   '/': (BuildContext context) => HomeScreen(),
   '/randomWords': (BuildContext context) => RandomWords(), //adding a 'named' route that does nothing rn
 };               