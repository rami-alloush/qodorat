import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qodorattest/db.dart';
import 'package:qodorattest/pages/chat_page.dart';
import 'package:qodorattest/models.dart';

class StartChatPage extends StatelessWidget {
  final db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<FirebaseUser>(context);

    return Scaffold(
      body: StreamBuilder<ChatThread>(
        stream: db.streamChat(user),
        builder: (context, snapshot) {
          var chatThread = snapshot.data;
          if (chatThread != null) {
            return ChatScreen();
          } else {
            return Center(
              child: RaisedButton(
                  child: Text('بدأ المحادثة مع الإدارة'),
                  onPressed: () => db.createChat(user.uid, user.email)),
            );
          }
        },
      ),
    );
  }
}
