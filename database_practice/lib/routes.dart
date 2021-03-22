import 'package:flutter/widgets.dart';
import 'screens/home.dart';
import 'screens/sellbook.dart';
import 'screens/buybook.dart';
import 'screens/login.dart';
import 'screens/cart.dart';
import 'screens/profile.dart';
import 'screens/random_words.dart';
import 'screens/databasetest.dart';

//organizes all the routes (which 'urls' link to which page)

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  //later add these routes to routes.dart
  '/': (BuildContext context) => HomeScreen(),
  '/buyBooks': (BuildContext context) => BuyBooks(),
  '/sellBooks': (BuildContext context) => SellBooks(),
  '/login': (BuildContext context) => Login(),
  //'/profile': (BuildContext context) => UserInfoScreen(),

  //'/cart': (BuildContext context) => Pay(),

  //removed random words
  //'/randomWords': (BuildContext context) => RandomWords(), 
  '/databaseTesting': (BuildContext context) => MyHomePage(),
};
