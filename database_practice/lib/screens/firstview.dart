import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FirstView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: const Color(0xFF75AE2EA),
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                SizedBox(
                  height: _height * 0.10,
                ),
                AutoSizeText(
                  "Welcome",
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                AutoSizeText(
                  "Get Started",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: _height * 0.10,
                ),
                ElevatedButton(
                    child: Text(
                      "Sign Up",
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/signup');
                    }),
                SizedBox(
                  height: _height * 0.10,
                ),
                ElevatedButton(
                    child: Text(
                      "Log In",
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    }),
              ])),
        ),
      ),
    );
  }
}
