import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String phone;
  final bool paid;

  User({this.id, this.email, this.phone, this.paid});

  factory User.fromMap(Map data) {
    return User(
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      paid: data['paid'] ?? false,
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
      id: doc.documentID,
      email: data['email'] ?? 'لا يوجد بريد الأكتروني',
      paid: data['paid'] ?? false,
      phone: data['phone'] ?? 'لا يوجد رقم جوال',
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
  final String videoURL;
  final String exploratoryText1;
  final String exploratoryText2;
  final int sectionCategory;
  final int sectionIndex;
  final int order;

  Lesson({
    this.id,
    this.title,
    this.videoURL,
    this.exploratoryText1,
    this.exploratoryText2,
    this.sectionCategory,
    this.sectionIndex,
    this.order,
  });

  factory Lesson.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Lesson(
      id: doc.documentID,
      title: data['title'] ?? 'لا يوجد عنوان لهذا الدرس',
      videoURL:
          data['videoURL'] ?? '8VK39xCrhhg',
      exploratoryText1: data['exploratoryText1'] ?? 'لا يوجد شرح اساسي',
      exploratoryText2: data['exploratoryText2'] ?? 'لا يوجد شرح إضافي',
      sectionCategory: data['sectionIndex'] ?? 0,
      sectionIndex: data['sectionIndex'] ?? 0,
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJSON() => {
        'title': title,
        'videoURL': videoURL,
        'exploratoryText1': exploratoryText1,
        'exploratoryText2': exploratoryText2,
        'sectionCategory': sectionCategory,
        'sectionIndex': sectionIndex,
        'order': order,
      };
}

class Question {
  final String id;
  final String question;
  final List choices;
  final String correctAnswer;

  Question({
    this.id,
    this.question,
    this.choices,
    this.correctAnswer,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Question(
      id: doc.documentID,
      question: data['question'] ?? 'لا يوجد سؤال',
      choices: data['choices'] ?? '0',
      correctAnswer: data['correctAnswer'] ?? '0',
    );
  }

  @override
  String toString() {
    return "السؤال: ${this.question}";
  }
}

class Score {
  final String id;
  final double score;
  final String preScore;
  final String postScore;

  Score({
    this.id,
    this.score,
    this.preScore,
    this.postScore,
  });

  factory Score.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Score(
      id: doc.documentID,
      score: data['score'] ?? -1,
      preScore: data['preScore'] ?? '-1',
      postScore: data['postScore'] ?? '-1',
    );
  }

  @override
  String toString() {
    return "score: $score";
  }
}
