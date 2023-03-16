import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gere_Tache/list_tache_page.dart';
import 'package:mrm/views/Admin/Gere_Tache/update-tache.dart';

class TacheCardAdmin extends StatelessWidget {
  final TacheModel taches;
  final UserModel user;

  const TacheCardAdmin({super.key, required this.taches, required this.user});

  @override
  Widget build(BuildContext context) {
    Color colors = Colors.red;
    Color back = Colors.white;
    return Container(
        child: Row(
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
                  Center(child: Text("${taches.ref}")),
                  Center(child: Text("${taches.title} ")),
                  Center(child: Text("${taches.createdBy}  ")),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateTachePage(
                              tache: taches,
                              user: user,
                            ),
                          ));

                      print("firas");
                    },
                    icon: Icon(Icons.update),
                    label: Text("Mise a jour"),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('Taches')
                          .doc(taches.id)
                          .delete();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FetchTachesViewAdmin(
                                    user: user,
                                  )));
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Supprimer"),
                  ),
                ],
              )),
        ),
      ],
    ));
  }
}
