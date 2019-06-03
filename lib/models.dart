
import 'package:cloud_firestore/cloud_firestore.dart';

class User {

  final String email;
  final bool paid;

  User({ this.email, this.paid });

  factory User.fromMap(Map data) {
    return User(
      email: data['email'] ?? '',
      paid: data['paid'] ?? false,
    );
  }

}

class ChatThread {
  final String id;
  final String email;

  ChatThread({ this.id, this.email});

  factory ChatThread.fromMap(Map data) {
    return ChatThread(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
    );
  }

//  factory ChatThread.fromFirestore(DocumentSnapshot doc) {
//    Map data = doc.data;
//
//    return ChatThread(
//      id: doc.documentID,
//      email: data['email'] ?? '',
//    );
//  }

}