// THIS IS THE HOME SCREEN! Textable Home

//import statements: You basically always have to import flutter/material.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 12),
                child: Image.asset(
                'assets/lakesidelogo.jpg', //replace this with either our own logo or smth
              ),
            ),
      title: Text('Textbook Exchange Home'),
      
    ),

    body: Container(
        child: Column(
          children: [
            SizedBox(height: 20), //adding space between widgets
            
            Text(
              'LS Textbook Xchange',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50, //how to specify?
                ),
              ),

            SizedBox(height: 20), //adding space between widgets

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
            ),
            
          ],
        ),
      
      )
    
    );
  }
}
