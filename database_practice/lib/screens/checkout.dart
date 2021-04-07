// a checkout screen: this is where the user would pay for their books

import 'package:url_launcher/url_launcher.dart'; //use this package to take buyer to external url to pay
import 'package:database_practice/models/tbuser.dart';
import 'login.dart';

import 'package:flutter/material.dart';

const _url = 'https://flutter.dev';

void main() => runApp(
      const MaterialApp(
        home: Material(
          child: Center(
            child: ElevatedButton(
              onPressed: _launchURL,
              child: Text('Show Flutter homepage'),
            ),
          ),
        ),
      ),
    );

void _launchURL() async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';