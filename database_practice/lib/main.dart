import 'package:firebase_core/firebase_core.dart'; //added based on this medium tutorial: https://medium.com/firebase-tips-tricks/how-to-use-cloud-firestore-in-flutter-9ea80593ca40
import 'package:flutter/material.dart';
import 'screens/signup.dart'; //importing routes file
import '/static/themes.dart'; //importing the file that specifies all the themes
import 'package:flutter/widgets.dart';
import '/screens/home.dart';
import '/screens/sellbook.dart';
import '/screens/buybook.dart';
import '/screens/login.dart';
//import 'screens/cart.dart';
import '/screens/profile.dart';
import '/screens/firstview.dart';
import 'package:provider/provider.dart';

void main() async {
  //created based on this Stack Overflow: https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: "Textbook Exchange App",
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signup': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signUp),
          '/login': (BuildContext context) =>
              SignUpView(authFormType: AuthFormType.signIn),
          '/home': (BuildContext context) => HomeController(),
          '/buyBooks': (BuildContext context) => BuyBooks(),
          '/sellBooks': (BuildContext context) => SellBooks(),
          //    '/login': (BuildContext context) => Login(),
          //'/profile': (BuildContext context) => UserInfoScreen(),

          //'/cart': (BuildContext context) => Pay(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.authStateChanges,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? HomeScreen() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class Provider extends InheritedWidget {
  final AuthService auth;
  Provider({
    Key key,
    Widget child,
    this.auth,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

// used https://stackoverflow.com/questions/65749767/error-the-method-inheritfromwidgetofexacttype-isnt-defined-for-the-class-bu
  static Provider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider);
}
