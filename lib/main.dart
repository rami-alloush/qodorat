import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorat/pages/login_signup_page.dart';
import 'package:qodorat/pages/home_page.dart';
import 'package:qodorat/db.dart';

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

class CheckLogin extends StatefulWidget {
  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  var _userType;

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    final db = DatabaseService();

    print("User: " + '$user');

    if (user == null) {
      return LoginSignUpPage();
    } else {
      return FutureBuilder(
          future: getUserType(user),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                switch (snapshot.data) {
                  case "not_verified":
                    return LoginSignUpPage();
                  case "admin":
                    return HomePage(); //AdminHomePage();
                  case "guest":
                    return HomePage(); //GuestHomePage();
                  case "paid":
                    return HomePage(); //PaidHomePage();
                }
            }
          });
    }
  }
}

getUserType(FirebaseUser user) async {
  final db = DatabaseService();
  var userType;

  if (!user.isEmailVerified) {
    userType = "not_verified";
  } else if (user.uid == "OKOBJxbEeVSzjr79X2QF3ZnDjUA3") {
    userType = "admin";
  } else {
    // Check Guest or Paid
    if (await db.isUserPaid(user)) {
      userType = "paid";
    } else {
      userType = "guest";
    }
  }

  print("UserType: " + '$userType' + ' ' + '${user.uid}');
  return userType;
}
