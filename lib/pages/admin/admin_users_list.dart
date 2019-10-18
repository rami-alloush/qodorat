import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:qodorattest/pages/admin/admin_user_details_page.dart';
import 'package:qodorattest/models.dart';

class UsersListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreAnimatedList(
      query: Firestore.instance.collection('users').orderBy("paid").snapshots(),
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (
        BuildContext context,
        DocumentSnapshot snapshot,
        Animation<double> animation,
        int index,
      ) {
        return FadeTransition(
            opacity: animation,
            child: UserItem(
              document: snapshot,
              animation: animation,
            ));
      },
    ); // end of FirestoreAnimatedList
  }
}

class UserItem extends StatelessWidget {
  UserItem({this.document, this.animation});

  final DocumentSnapshot document;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    User user = User.fromFirestore(document);

    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut),
      axisAlignment: -10.0,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.sentiment_satisfied),
          backgroundColor: Colors.white,
        ),
        title: Text(user.email),
        subtitle: Text(user.phone),
        trailing: user.paid
            ? Icon(
                Icons.done_all,
                color: Colors.green,
              )
            : Icon(
                Icons.do_not_disturb,
                color: Colors.red,
              ),
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetails(user: user),
              ),
            ),
      ),
    );
  }
}
