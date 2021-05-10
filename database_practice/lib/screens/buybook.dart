import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:database_practice/database.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/models/record.dart';
import 'package:database_practice/models/cart.dart';

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
                onPressed: viewCart //call the function _viewCart (you created)
                )
          ],
        ),
        body: DisplayBooks(cart));
  }

//DISPLAYS USERS CART
// eventually this will probably be it's own file because we might want users to be able to view their cart from
//    any of the screens rather than JUST the 'buy books' screen.
  void viewCart() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = cart.cartBooks.map((Record record) {
        return ListTile(
          title: Text(record.name, style: TextStyle(fontSize: 16)),
          trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                cart.removeFromCart(record);
                //refreshes the cart to see the new changes, source: https://stackoverflow.com/questions/55142992/flutter-delete-item-from-listview
                Navigator.of(context).pop();
                viewCart();
              }),
        );
      });

      final List<Widget> divided = ListTile.divideTiles(
              //styles the listTile??
              context: context,
              tiles: tiles)
          .toList(); //creates a list with the elements of this "iterable"

      return Scaffold(
          appBar: AppBar(title: Text('Cart')),
          body: Column(children: [
            Expanded(
              child: ListView(
                  padding: const EdgeInsets.only(top: 10.0),
                  children: divided), //see: final List<Widget> divided
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/checkout");
                },
                child: Text("Checkout"))
          ]));
    }));
  }
}

//DISPLAYS BOOK LIST
class DisplayBooks extends StatefulWidget {
  final Cart cart;
  DisplayBooks(this.cart);

  @override
  _DisplayBooksState createState() {
    return _DisplayBooksState();
  }
}

class _DisplayBooksState extends State<DisplayBooks> {
  TextEditingController _searchController = TextEditingController();
  List _allResults = [];
  List _searchResults = [];
  Future resultsLoaded;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getBookSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

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

  getBookSnapshots() async {
    var data = await database.collection('books').orderBy('price').get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            controller: _searchController,
            decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildListItem(
                        context, _searchResults[index], widget.cart)),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, DocumentSnapshot data, Cart cart) {
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
                    builder: (context) => DetailPage(record, cart),
                  ), //navigates to the details of the book page
                );
              }),
        ));
  }
}

//CREATE A PAGE THAT DISPLAYS BOOK DETAILS UPON CLICKING
class DetailPage extends StatefulWidget {
  final Record listing;
  final Cart cart;

  //DetailPage({Key key, @required this.listing}) : super(key: key);
  DetailPage(this.listing, this.cart);
  //const DetailPage ({ Key key, this.listing }): super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

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

                CircleAvatar(
                  //will put the image that user uploads in here!!
                  backgroundColor: CustomColors.lsMaroon,
                  radius: 90,
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
                    //add to cart
                    onPressed: () {
                      widget.cart.addToCart(widget.listing);
                      Navigator.pop(context);
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
