
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

class Weapon {
  final String id;
  final String name;
  final int hitpoints;
  final String img;

  Weapon({ this.id, this.name, this.hitpoints, this.img, });

  factory Weapon.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    
    return Weapon(
      id: doc.documentID,
      name: data['name'] ?? '',
      hitpoints: data['hitpoints'] ?? 0,
      img: data['img'] ?? ''
    );
  }

}