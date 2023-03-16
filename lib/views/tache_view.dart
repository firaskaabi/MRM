import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/NavigationDrawer.dart';
import 'package:mrm/views/fetch_taches.dart';

class TachesView extends StatelessWidget {
  final TacheModel tache;
  final UserModel user;

  const TachesView({
    Key? key,
    required this.tache,
    required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details de Taches"),
      ),
      drawer: NavigationDrawer(user: user),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.white70,
              shape: const RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.red,
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        tache.ref.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        tache.title.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "telphone :" + tache.tel.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          backgroundColor: Colors.red[200]),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 32,
                      ),
                      label: const Text(
                        'Retour',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FetchTachesView(
                                  user: user,
                                )));
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
