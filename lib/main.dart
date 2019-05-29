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
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);
    print("User: " + '$user');

    // should handle when signed in and not verified resend link)
    return (_userProperlyLogged(user)) ? HomePage() : LoginSignUpPage();
  }
}

bool _userProperlyLogged(user) {
//  if (!user.isEmailVerified) {
//    // user.sendEmailVerification();
//  }
//  return (user != null &&  user.isEmailVerified);
  print("user is checked");
  return (user != null);
}