// THIS IS THE HOME SCREEN! Textable Home

//import statements: You basically always have to import flutter/material.dart
import 'package:flutter/material.dart';
import 'package:database_practice/static/colors.dart';
import 'login.dart';

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
        title: Text('Textbook Exchange'),
      ),
      body: Container(
        color: CustomColors.lsMaroon,
        child: Column(
          children: [
            SizedBox(height: 20), //adding space between widgets

            Text(
              'LS Textbook Xchange',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50, //how to specify?
                color: Colors.white
              ),
            ),

            SizedBox(height: 20), //adding space between widgets

            Image.asset(
            'assets/textbooks.jpg', //replace this with either our own logo or smth
            ),

            SizedBox(height: 20), //adding space between widgets

            Wrap(children: [
              ElevatedButton( //make this bigger!
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Login/Sign Up")
                ),

                ElevatedButton( //make this bigger!
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  )
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/databaseTesting');
                },
                child: Text("database test")
                ),
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
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: CustomColors.lsMaroon,
              ),
            ),
            ListTile(
              title: Text('Cart'),
              onTap: () {
                Navigator.pushNamed(context, '/cart');
              },
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
                Navigator.pushNamed(context, '/sellBooks');
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
