import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'models.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;

  Future<void> createUser(FirebaseUser user) {
    return _db.collection('users').document(user.uid).setData({
      'email': '${user.email}',
      'paid': false,
    });
  }

  Future<User> getUser(FirebaseUser user) async {
    var snap = await _db.collection('users').document(user.uid).get();
    return User.fromMap(snap.data);
  }

  /// Get a stream of a single document
  Stream<User> streamUser(FirebaseUser user) {
    return _db
        .collection('users')
        .document(user.uid)
        .snapshots()
        .map((snap) => User.fromMap(snap.data));
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
