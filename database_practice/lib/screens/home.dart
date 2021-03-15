// THIS IS THE HOME SCREEN! Textable Home

//import statements: You basically always have to import flutter/material.dart
import 'package:flutter/material.dart';
import 'package:database_practice/static/colors.dart';

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

            Wrap(children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/sellBooks');
                  },
                  child: Text("Sell Books")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/buyBooks');
                  },
                  child: Text("Buy Books")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                  child: Text("Cart")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/randomWords');
                  },
                  child: Text("Random Words")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/databaseTesting');
                  },
                  child: Text("Database Test")),
            ]),
          ],
        ),
      ),
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: CustomColors.lsMaroon,
              ),
            ),
            ListTile(
              title: Text('Buy Books'),
              onTap: () {
                Navigator.pushNamed(context, '/buyBooks');
              },
            ),
            ListTile(
              title: Text('Sell Books'),
              onTap: () {
                Navigator.pushNamed(context, '/buyBooks');
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
      ),
    );
  }
}
