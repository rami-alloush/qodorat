import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';

class ChatListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreAnimatedList(
      query: Firestore.instance
          .collection('chats')
          .snapshots(),
      padding: new EdgeInsets.all(8.0),
      itemBuilder: (
        BuildContext context,
        DocumentSnapshot snapshot,
        Animation<double> animation,
        int index,
      ) {
        return FadeTransition(
            opacity: animation,
            child: ChatMessage(
              text: snapshot.documentID,
              animation: animation,
              user: "user",
            ));
      },
    ); // end of FirestoreAnimatedList
  }
}


class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animation, this.user});

  final String text;
  final Animation animation;
  final String user;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor:
        CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut),
        axisAlignment: -10.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Avatar
              new Container(
                margin: const EdgeInsets.only(right: 16.0, left: 8.0),
                child: new CircleAvatar(child: Icon(Icons.sentiment_satisfied)),
              ),
              // Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "user.uid",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
