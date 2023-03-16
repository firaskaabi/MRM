import 'package:cloud_firestore/cloud_firestore.dart';

class TacheModel {
  TacheModel({
    this.id,
    required this.ref,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.importance,
    required this.tel,
    this.toUser,
    this.isTraite,
    this.dateDebut,
    this.dateFin,
  });
  late final String ref;
  late final String title;
  late final String description;
  late final String createdBy;
  late final String tel;
  late final String importance;
  late final String? toUser;
  late final String? id;
  late final bool? isTraite;
  late final Timestamp? dateDebut;
  late final Timestamp? dateFin;

  TacheModel.fromJson(Map<String, dynamic> json, {required String docId}) {
    ref = json['ref'];
    title = json['title'];
    description = json['description'];
    createdBy = json['createdBy'];
    tel = json['tel'];
    importance = json['importance'];
    isTraite = json['isTraite'];
    toUser = json['toUser'];
    dateDebut = json['dateDebut'];
    dateFin = json['dateFin'];
    id = docId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ref'] = ref;
    data['title'] = title;
    data['description'] = description;
    data['createdBy'] = createdBy;
    data['tel'] = tel;
    data['importance'] = importance;
    data['isTraite'] = isTraite;
    data['toUser'] = toUser;
    data['dateDebut'] = dateDebut;
    data['dateFin'] = dateFin;

    return data;
  }

  TacheModel.fromSnapshot(DocumentSnapshot documentSnapshot)
      : ref = documentSnapshot.get('ref'),
        title = documentSnapshot.get('title'),
        description = documentSnapshot.get('description'),
        createdBy = documentSnapshot.get('createdBy'),
        tel = documentSnapshot.get('tel'),
        importance = documentSnapshot.get('importance'),
        dateDebut = documentSnapshot.get('dateDebut'),
        dateFin = documentSnapshot.get('dateFin'),
        isTraite = documentSnapshot.get('isTraite'),
        toUser = documentSnapshot.get('toUser'),
        id = documentSnapshot.id;
  factory TacheModel.fromMap(Map<String, dynamic> data) {
    return TacheModel(
      ref: data['ref'],
      title: data['title'],
      description: data['description'],
      createdBy: data['createdBy'],
      tel: data['tel'],
      importance: data['importance'],
    );
  }
}
