import 'package:flutter/material.dart';
import 'package:mrm/controllers/firestore_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gere_Tache/insert-tache.dart';
import 'package:mrm/views/Admin/Gere_Tache/tache_card_admin.dart';
import 'package:mrm/views/Admin/navigation_admin.dart';

class FetchTachesViewAdmin extends StatefulWidget {
  final UserModel user;

  const FetchTachesViewAdmin({super.key, required this.user});

  @override
  State<FetchTachesViewAdmin> createState() => _fetchTachesStatet();
}

class _fetchTachesStatet extends State<FetchTachesViewAdmin> {
  late Future<List<TacheModel>?> tache;

  List<TacheModel> tachesList = [];
  getTaches() async {
    setState(() {
      tache = Firestore.getTaches();
    });
    tachesList = (await tache)!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getTaches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("list de taches"),
      ),
      drawer: NavigationDrawerAdmin(user: widget.user),
      body: Stack(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.topCenter,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InsertTache(
                                currentUser: widget.user,
                              )),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter Tache"),
                ),
              )),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: FutureBuilder<List<TacheModel>?>(
                  future: tache,
                  builder: (context, tache) {
                    return tache.hasData
                        ? ListView.builder(
                            itemCount: tache.data!.length,
                            itemBuilder: ((context, index) {
                              return Column(children: [
                                TacheCardAdmin(
                                  taches: tache.data![index],
                                  user: widget.user,
                                ),
                              ]);
                            }),
                          )
                        : const Center(child: CircularProgressIndicator());
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
