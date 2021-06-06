import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:database_practice/database.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/models/record.dart';
import 'package:database_practice/models/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'checkout.dart';

//The book marketplace for people to buy textbooks
class BuyBooks extends StatefulWidget {
  @override
  _BuyBooksState createState() {
    return _BuyBooksState();
  }
}

class _BuyBooksState extends State<BuyBooks> {
  //represents the books in the cart
  final cart = new Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Book Marketplace'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons
                    .shopping_bag), //generates a list button in the actions widget
                onPressed: () async {
                  Navigator.of(context)
                      .pushReplacementNamed('/cart'); //goes to the cart page
                })
          ],
        ),
        body: DisplayBooks());
  }
}

//displays book list
class DisplayBooks extends StatefulWidget {
  @override
  _DisplayBooksState createState() {
    return _DisplayBooksState();
  }
}

class _DisplayBooksState extends State<DisplayBooks> {
  //controllers + lists are used for the search functionality
  //used this video tutorial: https://www.youtube.com/watch?v=H3CCtCmBUoQ
  TextEditingController _searchController = TextEditingController();
  List _allResults = [];
  List _searchResults = [];
  Future resultsLoaded;

  //sets listener + removes listener for the search controller (which reads from the search box)
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose;
  }

//if anything has changed, will get book snapshots from database
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getBookSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

//if the search has changed, searches for book in database that contains the string being typed into the search box
  searchResultsList() {
    var showResults =
        []; //showResults is either a list of books with the string or the entire list of books

    if (_searchController.text != "") {
      for (var book in _allResults) {
        var bookname = Record.fromSnapshot(book).name.toLowerCase();

        if (bookname.contains(_searchController.text.toLowerCase())) {
          showResults.add(book);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _searchResults = showResults;
    });
  }

  //get books from the database and order them by price (with lowest price first)
  getBookSnapshots() async {
    var data = await database
        .collection('books')
        .where('view status',
            isEqualTo:
                true) //this is used to make sure the books in a user's cart are not shown here
        .orderBy('price')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

//build book marketplace + display books
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Text(
                'This is the book marketplace. Search and/or filter for books in the search bar below, and tap on any listing to see more details and add it to your cart!'),
          ),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText:
                    "Search"), //used this to add hint text: https://stackoverflow.com/questions/49040679/flutter-how-to-make-a-textfield-with-hinttext-but-no-underline
          ),
          //pass searchResults list to build the list
          Expanded(
            child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildListItem(context, _searchResults[index])),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
        key: ValueKey(record.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
              title: Text(record.name),
              trailing: Text(record.price.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(record),
                  ), //navigates to the details of the book page
                );
              }),
        ));
  }
}

//a page that displays book details
class DetailPage extends StatefulWidget {
  final Record listing;

  DetailPage(this.listing);

  @override
  _DetailPageState createState() => _DetailPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        shadowColor: Colors.amber[100],
        child: SizedBox(
          width: 350,
          height: 530,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Align(alignment: Alignment.centerRight, child: CloseButton()),

                Icon(
                  Icons.menu_book_rounded,
                  color: CustomColors.lsMaroon,
                  size: 140,
                ),

                SizedBox(
                  height: 20,
                ), //SizedBox
                Text(
                  widget.listing.name,
                  style: TextStyle(
                    fontSize: 30,
                    color: CustomColors.lsMaroon,
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ), //Text
                Text(
                  "\$" + widget.listing.price.toString(),
                  style: TextStyle(
                    fontSize: 15,
                    color: CustomColors.lsMaroon,
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ), //Text
                SizedBox(
                  height: 20,
                ), //SizedBox
                Text(
                  //adds details: author, which user listed it, description, etc.
                  " Author: " +
                      widget.listing.author +
                      "\n Condition: " +
                      widget.listing.condition +
                      "\n Listed by: " +
                      widget.listing.username,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ), //Textstyle
                ), //Text
                SizedBox(
                  height: 20,
                ), //SizedBox
                ElevatedButton(
                    //add to cart - changes view status to false so it won't display in marketplace
                    //states that buyer = user so the user will only see their own cart purchases in the database
                    onPressed: () async {
                      await database
                          .collection("books")
                          .doc(widget.listing.doc_id)
                          .update({
                        "view status": false,
                        "buyer": auth.currentUser.uid,
                      });
                      Navigator.of(context).pushReplacementNamed('/cart');
                    },
                    child: Text("Add to Cart")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
