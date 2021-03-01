// THIS IS THE HOME SCREEN! Textable Home

//import statements: You basically always have to import flutter/material.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Textable Home'),
      ),
      body: Container(
        child: Column(
          children: [
            Row( children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/randomwords');
                },
                child: Text("Random Words App")
              )
            
              ]
            )
            
            // a list view of all the entries ig BuildListView()
            
          ],
        ),
      
      )
    );
  }
}
