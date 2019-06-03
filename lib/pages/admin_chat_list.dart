import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:qodorat/pages/chat_page.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreAnimatedList(
      query: Firestore.instance.collection('chats').snapshots(),
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (
        BuildContext context,
        DocumentSnapshot snapshot,
        Animation<double> animation,
        int index,
      ) {
        return FadeTransition(
            opacity: animation,
            child: ChaatItem(
              document: snapshot,
              animation: animation,
            ));
      },
    ); // end of FirestoreAnimatedList
  }
}

class ChaatItem extends StatelessWidget {
  ChaatItem({this.document, this.animation});

  final DocumentSnapshot document;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut),
      axisAlignment: -10.0,
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.sentiment_satisfied),
          backgroundColor: Colors.white,
        ),
        title: Text(document['email']),
//        subtitle: Text(document['phone']),
//        trailing: document['paid']
//            ? Icon(
//          Icons.done_all,
//          color: Colors.green,
//        )
//            : Icon(
//          Icons.do_not_disturb,
//          color: Colors.red,
//        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      targetUID: document.documentID,
                      userEmail: document['email'],
                    ))),
      ),
    );
  }
}