import 'package:flutter/material.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/controllers/firestore_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/NavigationDrawer.dart';
import 'package:mrm/views/arrive_page.dart';
import 'package:mrm/views/tache_view.dart';

class FetchTachesView extends StatefulWidget {
  final UserModel user;
  const FetchTachesView({Key? key, required this.user}) : super(key: key);
  @override
  _fetchTachesStatet createState() => _fetchTachesStatet();
}

class _fetchTachesStatet extends State<FetchTachesView> {
  late Future<List<TacheModel>?> taches;
  late Future<UserModel> user;
  late bool isAdmin;
  late int nbTaches = 0;
  getTaches() async {
    setState(() {
      taches = Firestore.getTachesCurrentUser();
    });
  }

  getNbTaches() async {
    int listLength = await taches.then(((list) => list!.length));
    setState(() {
      nbTaches = listLength;
    });
  }

  getUser() {
    user = Firestore.getUser();
  }

  @override
  void initState() {
    getUser();
    getTaches();
    getNbTaches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(nbTaches);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Planning"),
      ),
      drawer: NavigationDrawer(user: widget.user),
      body: FutureBuilder<List<TacheModel>?>(
          future: taches,
          builder: (context, taches) {
            return taches.hasData
                ? ListView.builder(
                    itemCount: nbTaches,
                    itemBuilder: ((context, index) {
                      return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 15),
                          child: Column(
                            children: [
                              if (taches.data![index].importance! == "Élevé")
                                ListTile(
                                  tileColor: Colors.green[50],
                                  title: Text(
                                    taches.data![index].ref,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: const SizedBox(
                                    height: 80.0,
                                    width: 20.0,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.red),
                                    ),
                                  ),
                                  onTap: () {
                                    if (taches.data![index].isTraite!) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => TachesView(
                                                    tache: taches.data![index],
                                                    user: widget.user,
                                                  )));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArriveTachePage(
                                                    tache: taches.data![index],
                                                    user: widget.user,
                                                  )));
                                    }
                                  },
                                ),
                              if (taches.data![index].importance! == "Normal")
                                ListTile(
                                  tileColor: Colors.green[50],
                                  title: Text(
                                    taches.data![index].ref,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: const SizedBox(
                                    height: 80.0,
                                    width: 20.0,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.orange),
                                    ),
                                  ),
                                  onTap: () {
                                    if (taches.data![index].isTraite!) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => TachesView(
                                                    tache: taches.data![index],
                                                    user: widget.user,
                                                  )));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArriveTachePage(
                                                    tache: taches.data![index],
                                                    user: widget.user,
                                                  ),),);
                                    }
                                  },
                                ),
                              if (taches.data![index].importance! == "Bas")
                                ListTile(
                                  tileColor: Colors.green[50],
                                  title: Text(
                                    taches.data![index].ref,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: const SizedBox(
                                    height: 80.0,
                                    width: 20.0,
                                    child: DecoratedBox(
                                      decoration:
                                          BoxDecoration(color: Colors.grey),
                                    ),
                                  ),
                                  onTap: () {
                                    if (taches.data![index].isTraite!) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => TachesView(
                                                    tache: taches.data![index],
                                                    user: widget.user,
                                                  )));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArriveTachePage(
                                                    tache: taches.data![index],
                                                    user: widget.user,
                                                  )));
                                    }
                                  },
                                ),
                            ],
                          ));
                    }),
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
