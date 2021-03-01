// THIS IS THE HOME SCREEN! Textable Home

//import statements: You basically always have to import flutter/material.dart
import 'package:flutter/material.dart';

import 'package:database_practice/routes.dart';

import 'random_words.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('Textbook Exchange Home'),
    
    ),
    body: Container(
        child: Column(
          children: [
            Row( children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RandomWords()));
                },
                child: Text("Random Words")
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/databaseTesting');
                },
                child: Text("Database Test")
              ),
  
              ]
            )
            
            // a list view of all the entries ig BuildListView()
            
          ],
        ),
      
      )
    
    );
  }
}
