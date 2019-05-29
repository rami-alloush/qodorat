import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorat/pages/login_signup_page.dart';
import 'package:qodorat/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            stream: FirebaseAuth.instance.onAuthStateChanged)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [const Locale("ar")],
        theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.deepOrange,
            primarySwatch: Colors.orange,
            buttonTheme: ButtonThemeData(buttonColor: Colors.white)),
        home: CheckLogin(),
      ),
    );
  }
}

class CheckLogin extends StatelessWidget {
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    print("User: " + '$user');
    if (user == null) {
      return LoginSignUpPage();
    } else {
      var userType = getUserType(user);
      switch (userType) {
        case "not_verified":
          return LoginSignUpPage();
          break;
        case "admin":
          return HomePage(); //AdminHomePage();
          break;
        case "guest":
          return HomePage(); //GuestHomePage();
          break;
        case "paid":
          return HomePage(); //PaidHomePage();
          break;
      }
    }
  }
}

getUserType(FirebaseUser user) {
  var userType = "guest";

  if (!user.isEmailVerified) {
    userType = "not_verified";
  }

  if (user.uid == "OKOBJxbEeVSzjr79X2QF3ZnDjUA3") {
    userType = "admin";
  } else {
    // Check Guest or Paid

  }

  print("UserType: " + '$userType' + ' ' + '${user.uid}');
  return userType;
}
