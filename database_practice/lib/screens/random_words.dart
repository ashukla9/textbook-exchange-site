// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//THE RANDOM WORDS TEST APP from the tutorial we both completed!

class RandomWords extends StatefulWidget {
  //is this like a constructor?
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  //then is this a method..? Not quite. Its creating this builded state
  final _randomWordPairs = <WordPair>[]; //[] = list
  final _savedWordPairs = Set<WordPair>(); // a set is a set of UNIQUE objects

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index =
            item ~/ 2; //calculate number of word pairs in list minus dividers

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs()
              .take(10)); //take=create, generateWordPairs is default package
        }

        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
        title: Text(pair.asPascalCase, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
            color: alreadySaved ? Colors.red : null),
        //? = "if it is [condition]", : = "else (if not)"
        onTap: () {
          setState(() {
            //setState -- create a function that sets the 'state' of the wordPair
            if (alreadySaved) {
              _savedWordPairs.remove(pair);
            } else {
              _savedWordPairs.add(pair);
            }
          });
        }); //list tile is one row in listView
    // ^ pair is variable, asPascalCase is a default method in english words pckg
  }

  void _pushSaved() {
    //navigates to a new 'route' or page

    Navigator.of(context).push(
        //Navigator is a widget to manage the accumulated 'Routes' (actions user takes from page to page)

        MaterialPageRoute(
            //material page route is basically a new page congstructor
            builder: (BuildContext context) {
      //builder defines the context of the page

      final Iterable<ListTile> tiles = _savedWordPairs.map((WordPair pair) {
        //creates an Iterable object of all your hearted wordPairs
        // pass a function into 'map'?
        return ListTile(
            //returns a list of wordPairs
            title: Text(pair.asPascalCase, style: TextStyle(fontSize: 16)));
      });

      final List<Widget> divided = ListTile.divideTiles(
              //styles the listTile??
              context: context,
              tiles: tiles)
          .toList(); //creates a list with the elements of this "iterable"

      return Scaffold(
          appBar: AppBar(title: Text('Saved WordPairs')),
          body: ListView(children: divided //see: final List<Widget> divided
              ));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WordPair Generator'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                    Icons.list), //generates a list button in the actions widget
                onPressed:
                    _pushSaved //call the function _pushSaved (you created)
                )
          ],
        ),
        body: _buildList());
  }
}
