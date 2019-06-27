import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:qodorat/pages/login_signup_page.dart';
import 'package:qodorat/pages/admin/admin_home_page.dart';
import 'package:qodorat/pages/paid/paid_home_page.dart';
import 'package:qodorat/pages/guest/guest_home_page.dart';
import 'package:qodorat/db.dart';

FirebaseAnalytics analytics = FirebaseAnalytics();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
            stream: FirebaseAuth.instance.onAuthStateChanged),
//        Stream<Firestore>.value(
//            value: Firestore.instance.settings(
//                timestampsInSnapshotsEnabled: true,
//                persistenceEnabled: true,
//                sslEnabled: true), ;
//        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          const FallbackCupertinoLocalisationsDelegate(),
        ],
        supportedLocales: [const Locale("ar")],
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        theme: ThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            primaryColor: Colors.lightGreen,
            primarySwatch: Colors.green,
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.green,
            )),
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
    final db = DatabaseService();
//    print("User: " + '$user');

    final _loadingScaffold = Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.white, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Center(
        child: new Text(
          'جاري التحميل ...',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ));

    // Test Page
//    return ChatScreen();

    // Start render based on userType
    if (user == null) {
      return LoginSignUpPage();
    } else {
      var userType = getUserType(user);
      switch (userType) {
        case "not_verified":
          return LoginSignUpPage();
        case "admin":
          return AdminHomePage();
        case "registered":
          return FutureBuilder<bool>(
            future: db.isUserPaid(user),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return _loadingScaffold;
                case ConnectionState.done:
                  if (snapshot.hasError)
                    return Scaffold(
                        body: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.deepOrange, Colors.orange[600]],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: Center(
                        child: new Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ));
                  print('isPaid? ${snapshot.data}');
                  if (snapshot.data) {
                    // Paid user
                    return PaidHomePage();
                  } else {
                    // Guest
                    return GuestHomePage();
                  }
              }
              return null; // unreachable
            },
          );
      }
    }
  }
}

getUserType(FirebaseUser user) {
  var userType;

  if (!user.isEmailVerified) {
    userType = "not_verified";
  } else if (user.uid == "OKOBJxbEeVSzjr79X2QF3ZnDjUA3") {
    userType = "admin";
  } else {
    // Check Guest or Paid
    userType = "registered";
  }

  analytics.logLogin();
  print("UserType: " + '$userType' + ' ' + '${user.uid}');
  return userType;
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
