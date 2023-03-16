import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/NavigationDrawer.dart';
import 'package:mrm/views/clouture_page.dart';
import 'package:mrm/views/fetch_taches.dart';

class ArriveTachePage extends StatelessWidget {
  final TacheModel tache;
  final UserModel user;

  const ArriveTachePage({Key? key, required this.tache, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tache.importance == "Bas") {}
    if (tache.importance == "Normal") {}
    if (tache.importance == "Élevé") {}
    return Scaffold(
      appBar: AppBar(
        title: Text("ARRIVE"),
      ),
      drawer: NavigationDrawer(user: user),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            if (tache.importance == "Élevé")
              const SizedBox(
                height: 10.0,
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                ),
              ),
            if (tache.importance == "Bas")
              const SizedBox(
                height: 10.0,
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ),
            if (tache.importance == "Normal")
              const SizedBox(
                height: 10.0,
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.orange),
                ),
              ),
            Card(
              margin: const EdgeInsets.all(20.0),
              shape: RoundedRectangleBorder(
                //<-- SEE HERE
                side: BorderSide(
                  color: Colors.greenAccent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 15,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          tache.ref.toString() + " " + tache.title.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          tache.description.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          tache.createdBy.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "telphone :" + tache.tel.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        backgroundColor: Colors.green),
                    icon: const Icon(
                      Icons.arrow_right_alt_outlined,
                      size: 32,
                    ),
                    label: const Text(
                      'Arrivé',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Taches")
                          .doc(tache.id)
                          .update({"dateDebut": DateTime.now()});

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ClotureTachePage(
                            tache: tache,
                            user: user,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.red[200]),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 32,
                    ),
                    label: const Text(
                      'Retour',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => FetchTachesView(
                                user: user,
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
