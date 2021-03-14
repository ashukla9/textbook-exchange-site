import 'package:firebase_core/firebase_core.dart'; //added based on this medium tutorial: https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40
import 'package:flutter/material.dart';

import 'routes.dart'; //importing routes file
import 'static/themes.dart'; //importing the file that specifies all the themes

void main() async {
  //created based on this Stack Overflow: https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes:
          routes, //routes is the Map we have in routes.dart [source: https://morioh.com/p/99b14cbf048e]
      theme: CustomTheme.lightTheme,
    );
  }
}
