import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final auth = FirebaseAuth.instance;
final analytics = new FirebaseAnalytics();

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();
  FirebaseUser user;
  bool _isComposing = false;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    user = await auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: new AppBar(title: new Text("محادثة")),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
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
              decoration:
                  new InputDecoration.collapsed(hintText: "Send a message"),
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
//    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

//  Future<Null> _ensureLoggedIn() async {
//    GoogleSignInAccount user = googleSignIn.currentUser;
//    if (user == null)
//      user = await googleSignIn.signInSilently();
//    if (user == null)
//      await googleSignIn.signIn();
//  }

  void _sendMessage({String text}) {
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
      user: user,
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
    analytics.logEvent(name: 'send_message');
  }

  @override
  void dispose() {
    //new
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController, this.user});

  final String text;
  final AnimationController animationController;
  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.linearToEaseOut),
        axisAlignment: -10.0,
        child: new Container(
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
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      user.uid,
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    new Container(
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
