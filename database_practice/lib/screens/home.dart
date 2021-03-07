// THIS IS THE HOME SCREEN! Textable Home

//import statements: You basically always have to import flutter/material.dart
import 'package:flutter/material.dart';

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
            Wrap( children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/sellBooks');
                },
                child: Text("Sell Books")
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/buyBooks');
                },
                child: Text("Buy Books")
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/randomWords');
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
            

          ],
        ),
      
      )
    
    );
  }
}
