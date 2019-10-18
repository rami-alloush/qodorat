import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/firestore_ui.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:qodorattest/db.dart';

final db = DatabaseService();
final analytics = new FirebaseAnalytics();

class ChatScreen extends StatefulWidget {
  ChatScreen({this.targetUID, this.userEmail});

  final userEmail;
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
  Firestore _firestore = Firestore.instance;

  _setFirestoreSettings() async {
    await _firestore.settings(
        timestampsInSnapshotsEnabled: true,
        persistenceEnabled: true,
        sslEnabled: true);
  }

  @override
  void initState() {
    _setFirestoreSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);

    isAdmin = widget.targetUID != null ? true : false;
    _chatDocID = widget.targetUID == null ? user.uid : widget.targetUID;

    return Scaffold(
      appBar: isAdmin
          ? AppBar(
          title: Text(widget.userEmail),
          // make sure chat is read for the admin before he leaves
          leading: IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context, true);
                db.readChatThread(chatDocID: _chatDocID);
              }))
          : null,
      body: Column(
        children: <Widget>[
          new Flexible(
            child: FirestoreAnimatedList(
              query: _firestore
                  .collection('chats')
                  .document(_chatDocID)
                  .collection("messages")
                  .orderBy("time", descending: true)
                  .snapshots(),
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (BuildContext context,
                  DocumentSnapshot snapshot,
                  Animation<double> animation,
                  int index,) {
                return FadeTransition(
                    opacity: animation,
                    child: ChatMessage(
                      document: snapshot,
                      animation: animation,
                      user: user,
                      isAdmin: isAdmin,
                    ));
              },
            ), // end of FirestoreAnimatedList
          ), // end of Flexible
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme
                .of(context)
                .cardColor),
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
              color: Theme
                  .of(context)
                  .accentColor,
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
    if (!isAdmin) {
      db.updateChatThread(chatDocID: _chatDocID);
    }
    analytics.logEvent(name: 'send_message');
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.document, this.animation, this.user, this.isAdmin});

  final document;
  final animation;
  final user;
  final isAdmin;
  final formatter = DateFormat("yyyy-MM-dd | h:ma"); //.yMd().add_jm(); //

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
      CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut),
      axisAlignment: -10.0,
      child: document["sender"] == user.uid
      // Own message (Right)
          ? ListTile(
        leading: CircleAvatar(
          child: Icon(
            isAdmin ? Icons.settings : Icons.sentiment_satisfied,
            color: Colors.green,
          ),
          backgroundColor: Colors.white,
        ),
        title: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                )),
            child: Text(document['text'])),
        subtitle: Text(
          formatter.format(document['time'].toDate()),
          style: TextStyle(fontSize: 14.0),
        ),
      )
      // Other message (Left)
          : ListTile(
        trailing: CircleAvatar(
          child: Icon(
            isAdmin ? Icons.sentiment_satisfied : Icons.settings,
          ),
          backgroundColor: Colors.white,
        ),
        title: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
                borderRadius: BorderRadius.all(
                  Radius.circular(16.0),
                )),
            child: Text(document['text'])),
        subtitle: Text(
          formatter.format(document['time'].toDate()),
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
