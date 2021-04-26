import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:database_practice/static/colors.dart';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: CustomColors.offWhite,
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                SizedBox(
                  height: _height * 0.10,
                ),
                AutoSizeText(
                  "WELCOME",
                  textAlign: TextAlign.center,
                  textScaleFactor: 3,
                ),
                AutoSizeText(
                  "The place for Lakesiders to resell and reuse textbooks.",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                ElevatedButton(
                    child: Text(
                      "Get Started",
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signup');
                    }),
                ElevatedButton(
                    child: Text(
                      "Log In",
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                Image.asset(
                  'assets/textbooks.png', //replace this with either our own logo or smth
                ),
              ])),
        ),
      ),
    );
  }
}
