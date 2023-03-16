import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/controllers/firestore_controller.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Acceuil.dart';
import 'package:mrm/views/fetch_taches.dart';
import 'package:mrm/views/feuille_route_page.dart';
import 'package:mrm/views/home.dart';
import 'package:mrm/views/notif.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AcceuilPage extends StatefulWidget {
  const AcceuilPage({super.key});
  @override
  State<AcceuilPage> createState() => _AcceuilState();
}

class _AcceuilState extends State<AcceuilPage> {
  late Future<UserModel> user;
  late Future<int> nbTaches;
  late UserModel u = new UserModel(
      name: '', email: '', telephone: '', isAdmin: false, docId: '');
  String nbT = '';
  getUser() {
    user = Firestore.getUser();
  }

  getUserCurrent() async {
    final actuelUser =
        await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      List<UserModel> userList =
          List.from(actuelUser.docs.map((doc) => UserModel.fromSnapshot(doc)));
      for (var i = 0; i < userList.length; i++) {
        if (Auth().currentUser!.uid == userList[i].id.toString()) {
          u = userList[i];
        }
      }
    });
  }

  getNbTaches() {
    nbTaches = Firestore.getNbTaches();
    setState(() {
      nbTaches.then((value) => setState(() {
            nbT = value.toString();
          }));
    });
  }

  getNotification() {
    FirebaseFirestore.instance
        .collection("Taches")
        .where('toUser', isEqualTo: Auth().currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = {};
          data[change.doc.id] = change.doc.data();

          Notif.showBigTextNotification(
              title: "${change.doc.get('ref')}",
              body: "${change.doc.get('title')}",
              fln: flutterLocalNotificationsPlugin);
        }
      });
    });
  }

  @override
  void initState() {
    getUser();
    getNbTaches();

    Notif.initialize(flutterLocalNotificationsPlugin);
    getNotification();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getNbTaches();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: user,
      builder: (context, user) {
        if (user.hasData) {
          if (!user.data!.isAdmin) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Acceuil"),
              ),
              drawer: Drawer(
                backgroundColor: Colors.blue[50],
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    DrawerHeader(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/chef.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                        child: Container()),
                    ListTile(
                      leading: Icon(
                        user.data!.isAdmin ? Icons.home : Icons.home,
                        size: 30,
                      ),
                      title: user.data!.isAdmin
                          ? const Text(
                              'ACCEUIL',
                            )
                          : const Text(
                              'ACCEUIL',
                            ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AcceuilPage(),
                          ),
                        );
                      },
                    ),
                    if (!user.data!.isAdmin)
                      ListTile(
                        leading: const Icon(
                          Icons.table_chart,
                          size: 30,
                        ),
                        title: const Text(
                          'PLANNING',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FetchTachesView(
                                user: u,
                              ),
                            ),
                          );
                        },
                      ),
                    if (!user.data!.isAdmin)
                      ListTile(
                        leading: const Icon(
                          Icons.file_copy,
                          size: 30,
                        ),
                        title: const Text(
                          'FEUILLE DE ROUTE',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeuilleDeRoutePage(),
                            ),
                          );
                        },
                      ),
                    if (!user.data!.isAdmin)
                      ListTile(
                        leading: const Icon(
                          Icons.new_label,
                          size: 30,
                        ),
                        title: const Text(
                          'NOUVEAU',
                        ),
                        onTap: () {
                          Notif.showBigTextNotification(
                            title: "message",
                            body: "body",
                            fln: flutterLocalNotificationsPlugin,
                          );
                        },
                      ),
                    if (!user.data!.isAdmin)
                      ListTile(
                        leading: const Icon(
                          Icons.history,
                          size: 30,
                        ),
                        title: const Text(
                          'HISTORIQUE',
                        ),
                        onTap: () {},
                      ),
                    if (!user.data!.isAdmin)
                      ListTile(
                        leading: const Icon(
                          Icons.settings,
                          size: 30,
                        ),
                        title: const Text(
                          'REGLAGE',
                        ),
                        onTap: () {},
                      ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        size: 30,
                      ),
                      title: const Text(
                        'Déconnecter',
                      ),
                      onTap: () {
                        Auth().signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const HomePage())),
                            (route) => false);
                      },
                    ),
                  ],
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Image(
                      image: AssetImage("assets/images/chef.png"),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FetchTachesView(
                                user: u,
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(Icons.menu_book),
                          title: const Text('padding'),
                          subtitle: Text('${nbT}'),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          leading: Icon(Icons.menu_book),
                          title: Text('MISIION AUTRE'),
                          subtitle: Text("8"),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)),
                      child: GestureDetector(
                        onTap: () {},
                        child: const ListTile(
                          leading: Icon(Icons.menu_book),
                          title: Text('FEUILLE DE ROUTE'),
                          subtitle: Text("8"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const AcceuilAdminPage();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
