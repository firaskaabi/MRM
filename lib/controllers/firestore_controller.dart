import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mrm/models/tache_model.dart';

import '../models/dish_model.dart';
import '../models/user_model.dart';

import 'auth_controller.dart';

class Firestore {
  static final _firestore = FirebaseFirestore.instance;

  static Future addUserWithId(String documentId, UserModel user) async {
    await _firestore.collection('users').doc(documentId).set(user.toJson());
  }

  static Future<UserModel> getUser() async {
    var document =
        await _firestore.collection('users').doc(Auth().currentUser!.uid).get();

    UserModel user = UserModel.fromJson(document.data()!, docId: document.id);
    return user;
  }

  static Future addDish(String dishName) async {
    await _firestore
        .collection("dishes")
        .add(DishModel(name: dishName).toJson());
  }

  static addTache(TacheModel tacheModel) {
    _firestore.collection("Taches").add(TacheModel(
          ref: tacheModel.ref,
          title: tacheModel.title,
          description: tacheModel.description,
          createdBy: tacheModel.createdBy,
          importance: tacheModel.importance,
          toUser: tacheModel.toUser,
          tel: tacheModel.tel,
          isTraite: false,
        ).toJson());
  }

  static Future<List<UserModel>?> getUsers() async {
    var userDocumen = await _firestore.collection('users').get();
    List<UserModel> users = [];
    for (var tacheDocument in userDocumen.docs) {
      UserModel user =
          UserModel.fromJson(tacheDocument.data(), docId: tacheDocument.id);
      users.add(user);
    }
    return users;
  }

  static Future<int> getNbTaches() async {
    var tachesDocument = await _firestore
        .collection('Taches')
        .where('toUser', isEqualTo: Auth().currentUser!.uid)
        .get();
    List<TacheModel> taches = [];
    for (var tacheDocument in tachesDocument.docs) {
      TacheModel tach =
          TacheModel.fromJson(tacheDocument.data(), docId: tacheDocument.id);
      taches.add(tach);
    }
    return taches.length;
  }

  static Future<List<TacheModel>?> getTaches() async {
    var tachesDocument = await _firestore.collection('Taches').get();
    List<TacheModel> taches = [];
    for (var tacheDocument in tachesDocument.docs) {
      TacheModel tach =
          TacheModel.fromJson(tacheDocument.data(), docId: tacheDocument.id);
      taches.add(tach);
    }
    return taches;
  }

  static Future<TacheModel> getTache(id) async {
    var tachesDocument = await _firestore.collection('Taches').get();
    List<TacheModel> taches = [];
    TacheModel tach;
    for (var tacheDocument in tachesDocument.docs) {
      tach = TacheModel.fromJson(tacheDocument.data(), docId: tacheDocument.id);
      if (tach.id == id) return tach;
    }
    return TacheModel(
        ref: 'ref',
        title: 'title',
        description: 'description',
        createdBy: 'createdBy',
        importance: 'importance',
        tel: 'tel');
  }

  static Future<List<TacheModel>?> getTachesCurrentUserTraite() async {
    var tachesDocument = await _firestore
        .collection('Taches')
        .where('toUser', isEqualTo: Auth().currentUser!.uid)
        .where('isTraite', isEqualTo: true)
        .get();

    List<TacheModel> taches = [];
    for (var tacheDocument in tachesDocument.docs) {
      TacheModel tach =
          TacheModel.fromJson(tacheDocument.data(), docId: tacheDocument.id);
      taches.add(tach);
    }
    return taches;
  }

  static Future<List<TacheModel>?> getTachesCurrentUser() async {
    var tachesDocument = await _firestore
        .collection('Taches')
        .where('toUser', isEqualTo: Auth().currentUser!.uid)
        .get();

    List<TacheModel> taches = [];
    for (var tacheDocument in tachesDocument.docs) {
      TacheModel tach =
          TacheModel.fromJson(tacheDocument.data(), docId: tacheDocument.id);
      taches.add(tach);
    }
    return taches;
  }

  static Future<List<DishModel>?> getDishes() async {
    var dishesDocument = await _firestore.collection('dishes').get();
    List<DishModel> dishes = [];
    final userDoc =
        await _firestore.collection('users').doc(Auth().currentUser!.uid).get();

    for (var dishDocument in dishesDocument.docs) {
      DishModel dish =
          DishModel.fromJson(dishDocument.data(), docId: dishDocument.id);

      if (userDoc.data()!['isAdmin']) {
        dish.isFavorite = false;
      } else {
        List<dynamic>? favList = userDoc.data()!['favorites'];
        if (favList == null || favList.isEmpty) {
          dish.isFavorite = false;
        } else {
          dish.isFavorite = favList.contains(dishDocument.id);
        }
      }
      dishes.add(dish);
    }
    return dishes;
  }

  static deleteDish(String id) async {
    await _firestore.collection('dishes').doc(id).delete();
  }

  static addFavorite(String id) async {
    final doc =
        await _firestore.collection('users').doc(Auth().currentUser!.uid).get();

    List<dynamic>? favorites = doc.data()!['favorites'] ?? [];
    favorites?.add(id);
    final favDoc = _firestore.collection('users').doc(Auth().currentUser!.uid);
    await favDoc.update({'favorites': favorites});
  }

  static removeFavorite(String id) async {
    final doc = _firestore.collection('users').doc(Auth().currentUser!.uid);
    List<dynamic> favorites = [];
    await doc.get().then((snapshot) {
      favorites.addAll(snapshot.data()?['favorites']);
    });
    favorites.removeWhere((element) => element == id);
    await doc.update({'favorites': favorites});
  }

  static Future<List<DishModel>?> getFavorites() async {
    final dishesDocument = await _firestore.collection('dishes').get();
    List<DishModel> dishes = [];
    final doc =
        await _firestore.collection('users').doc(Auth().currentUser!.uid).get();
    List<dynamic> favorites = doc.data()!['favorites'] ?? [];

    for (var dish in dishesDocument.docs) {
      if (favorites.contains(dish.id)) {
        dishes.add(DishModel.fromJson(dish.data(), docId: dish.id));
      }
    }
    return dishes;
  }
}
