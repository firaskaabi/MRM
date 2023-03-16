import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? fullName;
  String? email;
  String? role;
  Users({required id, required fullName, required email, required role});

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role,
      };
  Users.fromSnapshot(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.get('id'),
        fullName = documentSnapshot.get('full_name'),
        email = documentSnapshot.get('email'),
        role = documentSnapshot.get('role');
}
