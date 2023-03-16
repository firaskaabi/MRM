import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  late String name;
  late String email = '';
  late String telephone = '';
  late bool isAdmin;
  late final String? id;

  UserModel(
      {required this.name,
      required this.isAdmin,
      required this.email,
      required this.telephone,
      required String docId});

  UserModel.fromJson(Map<String, dynamic> json, {required String docId}) {
    name = json['name'];
    isAdmin = json['isAdmin'];
    telephone = json['telephone'];
    email = json['email'];

    id = docId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['isAdmin'] = isAdmin;
    data['telephone'] = telephone;
    data['email'] = email;

    return data;
  }

  UserModel.fromSnapshot(DocumentSnapshot documentSnapshot)
      : id = documentSnapshot.id,
        name = documentSnapshot.get('name');
}
