import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final bool paid;

  User({this.email, this.paid});

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

  ChatThread({this.id, this.email});

  factory ChatThread.fromMap(Map data) {
    return ChatThread(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
    );
  }
}

class Lesson {
  final String id;
  final String title;
  final int sectionCategory;
  final int sectionIndex;
  final int order;

  Lesson({
    this.id,
    this.title,
    this.sectionCategory,
    this.sectionIndex,
    this.order,
  });

  factory Lesson.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Lesson(
      id: doc.documentID,
      title: data['title'] ?? 'لا يوجد عنوان لهذا الدرس',
      sectionCategory: data['sectionIndex'] ?? 0,
      sectionIndex: data['sectionIndex'] ?? 0,
      order: data['order'] ?? 0,
    );
  }
}
