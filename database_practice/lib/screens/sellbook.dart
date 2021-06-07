import 'package:flutter/material.dart';
import 'package:database_practice/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

//where users can add books to be sold
class SellBooks extends StatefulWidget {
  @override
  _SellBooksState createState() {
    return _SellBooksState();
  }
}

class _SellBooksState extends State<SellBooks> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name, _price, _author, _condition, _error;
  final FirebaseAuth auth = FirebaseAuth.instance;

//validation for the form
  bool validate() {
    final form = _formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sell Books")),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        'Enter the below information about a book and click submit to upload it to the book marketplace! All fields are required.'),

                    SizedBox(
                      height: 20,
                    ), //adding space between header text and form

                    TextFormField(
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      decoration: InputDecoration(
                        hintText: "Textbook name",
                      ),
                      validator: (text) {
                        //used this to help: https://stackoverflow.com/questions/53424916/textfield-validation-in-flutter/53426227
                        //and this: https://www.youtube.com/watch?v=IxCeJS9yA8w
                        if (text == null || text.isEmpty) {
                          return 'Please input textbook name';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value,
                    ),
                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please input textbook price';
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      decoration: InputDecoration(
                        hintText: "Textbook price",
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _price = value,
                    ),
                    TextFormField(
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please input textbook author';
                        }
                        return null;
                      },
                      style: TextStyle(
                        fontSize: 22,
                      ),
                      decoration: InputDecoration(
                        hintText: "Textbook author",
                      ),
                      onSaved: (value) => _author = value,
                    ),
                    DropDownFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Please note book condition';
                        }
                        return null;
                      },
                      titleText: 'Book condition',
                      hintText: 'Please choose one',
                      value: _condition,
                      onSaved: (value) => _condition = value,
                      onChanged: (value) {
                        setState(() {
                          _condition = value;
                        });
                      },
                      dataSource: [
                        {
                          "display": "New",
                          "value": "New",
                        },
                        {
                          "display": "Slightly Used",
                          "value": "Slightly Used",
                        },
                        {
                          "display": "Moderately Used",
                          "value": "Moderately Used",
                        },
                        {
                          "display": "Extremely Used",
                          "value": "Extremely Used",
                        },
                      ],
                      textField: 'display',
                      valueField: 'value',
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () async {
                          if (validate()) {
                            try {
                              //add new book to database
                              await database
                                  .collection("books")
                                  .doc()
                                  .set({
                                    "name": _name,
                                    "price": double.parse(_price),
                                    "author": _author,
                                    "condition": _condition,
                                    "view status": "marketplace",
                                    "lister": auth.currentUser.uid,
                                    "lister username":
                                        auth.currentUser.displayName,
                                    "buyer email:": "N/A",
                                    "buyer": "N/A",
                                  })
                                  .then((value) => print("Textbook added"))
                                  //if there is an error
                                  .catchError((error) => print(
                                      "Failed to add textbook")); //or this
                              Navigator.of(context)
                                  .pushReplacementNamed('/buyBooks');
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    "Textbook added"), //https://stackoverflow.com/questions/45948168/how-to-create-toast-in-flutter
                              ));
                            } catch (e) {
                              setState(() {
                                _error = e.message;
                              });
                            }
                          }
                        }),
                  ],
                )))));
  }
}
