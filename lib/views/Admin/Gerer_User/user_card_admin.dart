import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gerer_User/list_user_page.dart';
import 'package:mrm/views/Admin/Gerer_User/update_user.dart';

class UserCardAdmin extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;

  UserCardAdmin({super.key, required this.user, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    Color colors = Colors.red;
    Color back = Colors.white;
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Card(
              color: back,
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.greenAccent,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(child: Text("${user.name}")),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateUserPage(
                            users: user,
                            currentUser: currentUser,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.update),
                    label: const Text("Mise a jour"),
                  ),
                  if (user.id != Auth().currentUser!.uid)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.id)
                            .delete();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FetchUserViewAdmin(
                                      user: currentUser,
                                    )));
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Supprimer"),
                    ),
                ],
              )),
        ),
      ],
    );
  }
}
