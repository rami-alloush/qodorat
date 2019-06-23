import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:qodorat/pages/chat_page.dart';

class ChatListPage extends StatelessWidget {
  final chatsStream = Firestore.instance
      .collection('chats')
      .orderBy("last_message", descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: chatsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data... Please wait');
          return ListView(
            children: snapshot.data.documents.map<Widget>(
              (document) {
                return ChatThread(
                  document: document,
                );
              },
            ).toList(),
          );
//          return FirestoreAnimatedList(
//            query: chatsStream,
//            padding: new EdgeInsets.all(8.0),
//            itemBuilder: (BuildContext context,
//                DocumentSnapshot snapshot,
//                Animation<double> animation,
//                int index,) {
//              return FadeTransition(
//                  opacity: animation,
//                  child: ChatThread(
//                    document: snapshot,
//                    animation: animation,
//                  ));
//            },
//          ); // end of FirestoreAnimatedList,
        });
  }
}

class ChatThread extends StatelessWidget {
  ChatThread({this.document});

  final DocumentSnapshot document;
//  final Animation animation = Animation();

  @override
  Widget build(BuildContext context) {
//    return SizeTransition(
//      sizeFactor:
//          CurvedAnimation(curve: Curves.linearToEaseOut),
//      axisAlignment: -10.0,
//      child:
      return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.sentiment_satisfied),
          backgroundColor: Colors.white,
        ),
        title: Text(document['email']),
        trailing: document['read']
            ? null
            : Icon(
                Icons.star,
                color: Colors.orange,
              ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                    targetUID: document.documentID,
                    userEmail: document['email'],
                  ),
            ),
          );
          db.readChatThread(chatDocID: document.documentID);
        },
//      ),
    );
  }
}
