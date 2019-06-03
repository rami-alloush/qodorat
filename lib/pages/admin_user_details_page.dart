import 'package:flutter/material.dart';
import 'package:qodorat/pages/chat_page.dart';

class UserDetails extends StatelessWidget {
  UserDetails({@required this.userDoc});

  final userDoc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(userDoc["email"]),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Card(
              child: ListTile(
            leading: Icon(Icons.alternate_email),
            title: Text(userDoc["email"]),
            subtitle: Text('البريد الإلكتروني'),
          )),
          Card(
              child: ListTile(
            leading: Icon(Icons.phone),
            title: Text(userDoc["phone"]),
            subtitle: Text('رقم الجوال'),
          )),
          Card(
              child: userDoc["paid"]
                  ? ListTile(
                      leading: Icon(Icons.done_all),
                      title: Text("عضو دائم - مدفوع"),
                      subtitle: Text('نوع المستخدم'),
                    )
                  : ListTile(
                      leading: Icon(Icons.do_not_disturb_on),
                      title: Text("زائر - مجاني"),
                      subtitle: Text('نوع المستخدم'),
                    )),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text("المحادثة"),
                  onPressed: () {
                    db.createChat(userDoc.documentID, userDoc["email"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  targetUID: userDoc.documentID,
                                  userEmail: userDoc['email'],
                                )));
                  },
                ),
              ),
              ButtonTheme(
                minWidth: 150.0,
                height: 50.0,
                child: RaisedButton(
                  child: Text("ترقية المستخدم"),
                  onPressed: userDoc["paid"]
                      ? null
                      : () {
                          _showConfirmUpgradeDialog(
                              context, userDoc.documentID);
                        },
                ),
              ),
            ],
          ),
        ]));
  }

  void _showConfirmUpgradeDialog(BuildContext context, userUID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("تأكيد ترقية المستخدم"),
          content: new Text(
              "ترقية المستخدم تعني انه اتم عملية الدفع بنجاح ويستطيع الوصول إلى محتوى الدروس. لايمكن التراجع عن هذه العملية!"),
          actions: <Widget>[
            FlatButton(
              child: new Text("إلغاء"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: new Text(
                "ترقية المستخدم",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                db.upgradeUser(userUID);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
