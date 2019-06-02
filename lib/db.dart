import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

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

  /// Get a stream of a single document
  Stream<User> streamUser(FirebaseUser user) {
    return _db
        .collection('users')
        .document(user.uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
  }

  /// Messages
  void sendMessage({String text, String chatDocID, FirebaseUser user}) {
    _db.collection('chats').document(chatDocID)
      ..collection('messages').add({
        'text': text,
        'sender': '${user.uid}',
        'time': FieldValue.serverTimestamp(),
      });
  }

  /// Query a subcollection
  Stream<List<Weapon>> streamWeapons(FirebaseUser user) {
    var ref = _db.collection('heroes').document(user.uid).collection('weapons');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Weapon.fromFirestore(doc)).toList());
  }

  Future<void> addWeapon(FirebaseUser user, dynamic weapon) {
    return _db
        .collection('heroes')
        .document(user.uid)
        .collection('weapons')
        .add(weapon);
  }

  Future<void> removeWeapon(FirebaseUser user, String id) {
    return _db
        .collection('heroes')
        .document(user.uid)
        .collection('weapons')
        .document(id)
        .delete();
  }
}
