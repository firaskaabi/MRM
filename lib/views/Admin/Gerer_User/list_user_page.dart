import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrm/controllers/firestore_controller.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gerer_User/user_card_admin.dart';
import 'package:mrm/views/Admin/navigation_admin.dart';

class FetchUserViewAdmin extends StatefulWidget {
  final UserModel user;

  const FetchUserViewAdmin({super.key, required this.user});

  @override
  State<FetchUserViewAdmin> createState() => _fetchUserState();
}

class _fetchUserState extends State<FetchUserViewAdmin> {
  late Future<List<UserModel>?> users;
  List<UserModel> userList = [];
  getTaches() async {
    setState(() {
      users = Firestore.getUsers();
    });
    userList = (await users)!;
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
        title: const Text("list des Users"),
      ),
      drawer: NavigationDrawerAdmin(user: widget.user),
      body: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.topCenter,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("Ajouter User"),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: FutureBuilder<List<UserModel>?>(
                  future: users,
                  builder: (context, user) {
                    return user.hasData
                        ? ListView.builder(
                            itemCount: user.data!.length,
                            itemBuilder: ((context, index) {
                              return Column(children: [
                                UserCardAdmin(
                                  user: user.data![index],
                                  currentUser: widget.user,
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
