import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:qodorat/db.dart';

final db = DatabaseService();
final analytics = new FirebaseAnalytics();

class ChatScreen extends StatefulWidget {
  ChatScreen({this.targetUID});

  final targetUID;

  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  bool isAdmin = false;
  FirebaseUser user;
  var _chatDocID;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    isAdmin = widget.targetUID != null ? true : false;
    _chatDocID = widget.targetUID == null ? user.uid : widget.targetUID;

    return Scaffold(
      body: Column(
        children: <Widget>[
          new Flexible(
            child: FirestoreAnimatedList(
              query: Firestore.instance
                  .collection('chats')
                  .document(_chatDocID)
                  .collection("messages")
                  .orderBy("time", descending: true)
                  .snapshots(),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (
                BuildContext context,
                DocumentSnapshot snapshot,
                Animation<double> animation,
                int index,
              ) {
                return FadeTransition(
                    opacity: animation,
                    child: ChatMessage(
                      text: snapshot['text'],
                      animation: animation,
                      user: user,
                    ));
              },
            ), // end of FirestoreAnimatedList
          ), // end of Flexible
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: new TextField(
              controller: _textController,
              onChanged: (String text) {
                setState(() {
                  _isComposing =
                      text.length > 0; // return bool based on the condition
                });
              },
              onSubmitted: _isComposing ? _handleSubmitted : null,
              decoration: new InputDecoration.collapsed(hintText: "نص الرسالة"),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(
                Icons.send,
              ),
              color: Theme.of(context).accentColor,
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text}) {
    db.sendMessage(text: text, chatDocID: _chatDocID, user: user);
    analytics.logEvent(name: 'send_message');
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animation, this.user});

  final String text;
  final Animation animation;
  final FirebaseUser user;

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
                child: new CircleAvatar(child: Icon(Icons.settings)),
              ),
              // Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.uid,
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
