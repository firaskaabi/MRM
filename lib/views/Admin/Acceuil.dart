import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gere_Tache/list_tache_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mrm/views/Admin/Gerer_User/list_user_page.dart';
import 'package:mrm/views/Admin/navigation_admin.dart';
import 'package:mrm/views/home.dart';

class AcceuilAdminPage extends StatefulWidget {
  const AcceuilAdminPage({super.key});

  @override
  State<AcceuilAdminPage> createState() => _AcceuilAdminState();
}

class _AcceuilAdminState extends State<AcceuilAdminPage> {
  late List<UserModel> users = [];
  late List<TacheModel> taches = [];
  late UserModel u = UserModel(
      name: '', email: '...', telephone: '...', isAdmin: false, docId: '');
  late int nbUser = 0;
  late int nbTache = 0;
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

  getUsers() async {
    final CollectionReference data =
        FirebaseFirestore.instance.collection("users");
    data.get().then((QuerySnapshot snapshot) {
      setState(() {
        nbUser = snapshot.size;
      });
      print('Le nombre de Users dans la collection est $nbUser');
    });
  }

  getTaches() async {
    final CollectionReference data =
        FirebaseFirestore.instance.collection("Taches");
    data.get().then((QuerySnapshot snapshot) {
      setState(() {
        nbTache = snapshot.size;
      });
      print('Le nombre de Taches dans la collection est $nbTache');
    });
  }

  @override
  void initState() {
    getUsers();
    getTaches();
    getUserCurrent();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUsers();
    getTaches();
  }

  @override
  Widget build(BuildContext context) {
    const url =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFMIYkLwQoD-pa4n6L0SpdosQ6845NQA5i7Wp7AWY&s';

    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home page'),
      ),
      drawer: NavigationDrawerAdmin(user: u),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/top.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(url),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${Auth().currentUser!.email}",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: GridView.count(
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    primary: false,
                    crossAxisCount: 2,
                    children: [
                      Card(
                        color: Colors.black38,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Nombre d'utilisateur",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SvgPicture.network(
                              'https://www.svgrepo.com/show/4529/user.svg',
                              height: 45,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${nbUser}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        color: Colors.black38,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Nombre des taches",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.pinkAccent,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SvgPicture.network(
                              'https://www.svgrepo.com/show/217182/tools-work.svg',
                              height: 45,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '${nbTache}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      primary: true,
                      crossAxisCount: 2,
                      children: [
                        Card(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    FetchUserViewAdmin(user: u),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                SvgPicture.network(
                                  'https://www.svgrepo.com/show/4529/user.svg',
                                  height: 100,
                                ),
                                const Text(
                                  "Gerer USER",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.lightGreenAccent,
                            ),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FetchTachesViewAdmin(
                                  user: u,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                SvgPicture.network(
                                  'https://www.svgrepo.com/show/217182/tools-work.svg',
                                  height: 128,
                                ),
                                const Text(
                                  "Gerer Taches",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            Auth().signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const HomePage())),
                                (route) => false);
                          },
                          icon: const Icon(Icons.logout_outlined),
                          label: const Text("Deconnection"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
