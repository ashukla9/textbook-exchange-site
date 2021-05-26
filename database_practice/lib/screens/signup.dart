import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:database_practice/main.dart';
import 'package:database_practice/static/colors.dart';
import 'package:database_practice/database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//used to fix: https://github.com/FirebaseExtended/flutterfire/issues/3213

  Stream<String> get authStateChanges => _firebaseAuth.authStateChanges().map(
        (User user) => user?.uid,
      );

  //Email Password sign up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    //Update the username: https://stackoverflow.com/questions/63658551/undefined-class-userupdateinfo-in-firebase-auth-flutter-2020
    await FirebaseAuth.instance.currentUser.updateProfile(displayName: name);
    return currentUser.user.uid;
  }

//Email and password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

//Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty.";
    }
    if (value.contains("@lakesideschool.org")) {
      return null;
    } else {
      return "Please use your Lakeside email.";
    }
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty.";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty.";
    }
    return null;
  }
}

enum AuthFormType { signIn, signUp }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _error;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signUp") {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          print("Signed in with ID $uid"); //not working
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
              _email, _password, _name);

          //insert into the users database a new file
          await database.collection("users").doc(uid).set({
            "displayName": _name,
            "paymentUrl": "Add a URL",
          });

          print("Created user with new ID $uid");
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: CustomColors.offWhite,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: Column(
          children: <Widget>[
            showAlert(),
            Container(
                margin: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    buildHeaderText(),
                    SizedBox(height: 50),
                    Form(
                      key: formKey,
                      child: Column(
                        children: buildInputs() + buildButtons(),
                      ),
                    )
                  ],
                ))
          ],
        )),
      ),
    );
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _error = null;
                  });
                })
          ],
        ),
      );
    }
    return Container(
      height: 0,
    );
  }

  Text buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = "Create new Account";
    } else {
      _headerText = "Sign In";
    }
    return Text(_headerText);
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );

    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(
          fontSize: 22,
        ),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );

    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(
            fontSize: 22,
          ),
          decoration: buildSignUpInputDecoration("First and Last Name"),
          onSaved: (value) => _name = value,
        ),
      );
    }

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: CustomColors.offWhite,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.lsMaroon, width: 1.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = "Create New Account";
      _newFormState = "signUp";
      _submitButtonText = "Sign In";
    } else {
      _switchButtonText = "Have an account? Sign In";
      _newFormState = "signIn";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * .7,
        child: ElevatedButton(
          child: Text(_submitButtonText),
          onPressed: submit,
        ),
      ),
      TextButton(
          child: Text(_switchButtonText),
          onPressed: () {
            switchFormState(_newFormState);
          }),
    ];
  }
}
