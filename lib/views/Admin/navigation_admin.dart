import 'package:flutter/material.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Acceuil.dart';
import 'package:mrm/views/Admin/Gere_Tache/list_tache_page.dart';
import 'package:mrm/views/Admin/Gerer_User/list_user_page.dart';
import 'package:mrm/views/home.dart';

class NavigationDrawerAdmin extends StatelessWidget {
  final UserModel user;
  const NavigationDrawerAdmin({Key? key, required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            leading: const Icon(
              Icons.home,
              size: 30,
            ),
            title: const Text(
              'ACCEUIL',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AcceuilAdminPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.table_chart,
              size: 30,
            ),
            title: const Text(
              'Gerer Taches',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FetchTachesViewAdmin(
                    user: user,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.file_copy,
              size: 30,
            ),
            title: const Text(
              'Gerer User ',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FetchUserViewAdmin(
                    user: user,
                  ),
                ),
              );
            },
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
                  MaterialPageRoute(builder: ((context) => const HomePage())),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
