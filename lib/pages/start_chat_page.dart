import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorat/db.dart';
import 'package:qodorat/pages/chat_page.dart';
import 'package:qodorat/models.dart';

class StartChatPage extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      body: StreamBuilder<ChatThread>(
        stream: db.streamChat(user),
        builder: (context, snapshot) {
          print(snapshot);
          var chatThread = snapshot.data;
          if (chatThread != null) {
            return ChatScreen();
          } else {
            return Center(
              child: RaisedButton(
                  child: Text('بدأ المحادثة مع الإدارة'),
                  onPressed: () => db.createChat(user)),
            );
          }
        },
      ),
    );
  }
}
