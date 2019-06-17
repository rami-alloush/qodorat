import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

//  DatabaseService() async {
//    String v =  _db.settings(
//        timestampsInSnapshotsEnabled: true,
//        persistenceEnabled: true,
//        sslEnabled: true);
//  }

  Future<void> createUser(FirebaseUser user, String phone) {
    return _db.collection('users').document(user.uid).setData({
      'email': '${user.email}',
      'phone': '$phone',
      'paid': false,
    });
  }

  Future<User> getUser(FirebaseUser user) async {
    var snap = await _db.collection('users').document(user.uid).get();
    return User.fromMap(snap.data);
  }

  Future<bool> isUserPaid(FirebaseUser user) async {
    var snap = await _db.collection('users').document(user.uid).get();
    return User.fromMap(snap.data).paid;
  }

  Future<void> upgradeUser(userUID) async {
    return _db.collection('users').document(userUID).updateData({
      'paid': true,
    });
  }

  /// Get a stream of a single document
  Stream<ChatThread> streamChat(FirebaseUser user) {
    return _db
        .collection('chats')
        .document(user.uid)
        .snapshots()
        .map((snap) => ChatThread.fromMap(snap.data));
  }

  Future<void> createChat(userUID, userEmail) {
    return _db.collection('chats').document(userUID).setData({
      'email': '$userEmail',
    });
  }

  /// Messages
  void sendMessage({String text, String chatDocID, FirebaseUser user}) {
    _db.collection('chats').document(chatDocID)
      ..collection('messages').add({
        'text': text,
        'sender': '${user.uid}',
        'time': DateTime.now() //FieldValue.serverTimestamp(),
      });
  }

  /// Lessons
  Future<DocumentReference> createLesson(lesson) {
    return _db.collection('lessons').add(lesson.toJSON());
  }

  Stream<List<Lesson>> streamLessons(int sectionCategory, int sectionIndex) {
    var ref = _db
        .collection('lessons')
        .where("sectionCategory", isEqualTo: sectionCategory)
        .where("sectionIndex", isEqualTo: sectionIndex)
        .orderBy("order");

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Lesson.fromFirestore(doc)).toList());
  }

  Future<void> deleteLesson(lesson) {
    return _db.collection('lessons').document(lesson.id).delete();
  }

  // Scores
  Stream<Score> streamScore(String examID, FirebaseUser user) {
    var ref = _db
        .collection('users')
        .document(user.uid)
        .collection("scores")
        .document(examID);

    return ref.snapshots().map((doc) => Score.fromFirestore(doc));
  }

  Future<void> updateScoreOnDB(examID, user, score) {
    return _db
        .collection('users')
        .document(user.uid)
        .collection('scores')
        .document(examID)
        .setData({
      'score': score,
    });
  }

  /// Questions
  Stream<List<Question>> streamQuestions(String examID) {
    var ref = _db.collection('exams').document(examID).collection("questions");

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Question.fromFirestore(doc)).toList());
  }

  Future<DocumentReference> createQuestion(examID, question) {
    return _db
        .collection('exams')
        .document(examID)
        .collection("questions")
        .add(question.toJSON());
  }

  Future<void> deleteQuestion(examID, question) {
    return _db
        .collection('exams')
        .document(examID)
        .collection("questions")
        .document(question.id)
        .delete();
  }
}
