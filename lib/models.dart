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
  final String videoURL;
  final String exploratoryTest1;
  final String exploratoryTest2;
  final int sectionCategory;
  final int sectionIndex;
  final int order;

  Lesson({
    this.id,
    this.title,
    this.videoURL,
    this.exploratoryTest1,
    this.exploratoryTest2,
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
          data['videoURL'] ?? 'https://www.youtube.com/watch?v=8VK39xCrhhg',
      exploratoryTest1: data['exploratoryTest1'] ?? 'لا يوجد شرح اساسي',
      exploratoryTest2: data['exploratoryTest2'] ?? 'لا يوجد شرح إضافي',
      sectionCategory: data['sectionIndex'] ?? 0,
      sectionIndex: data['sectionIndex'] ?? 0,
      order: data['order'] ?? 0,
    );
  }
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
