import 'package:flutter/widgets.dart';
import 'screens/home.dart';

import 'screens/sellbook.dart';

import 'screens/buybook.dart';
import 'screens/profile.dart';
import 'screens/databasetest.dart';
import 'screens/signup.dart'; 
import 'screens/checkout.dart';

import 'main.dart';

//organizes all the routes (which 'urls' link to which page)

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  //later add these routes to routes.dart
  '/': (BuildContext context) => HomeController(), //currently the same as bottom?? 
  '/home': (BuildContext context) => HomeController(),

  '/buyBooks': (BuildContext context) => BuyBooks(),
  '/sellBooks': (BuildContext context) => SellBooks(),
  '/login': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
  '/profile': (BuildContext context) => Profile(),
  '/signup': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
  '/cart': (BuildContext context) => BuyBooks(),

  '/checkout': (BuildContext context) => Checkout(),

  '/databaseTesting': (BuildContext context) => MyHomePage(),
};
