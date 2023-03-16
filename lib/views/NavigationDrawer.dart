import 'package:flutter/material.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/acceuil.dart';
import 'package:mrm/views/fetch_taches.dart';
import 'package:mrm/views/feuille_route_page.dart';
import 'package:mrm/views/home.dart';

class NavigationDrawer extends StatelessWidget {
  final UserModel user;

  const NavigationDrawer({Key? key, required this.user}) : super(key: key);
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
            leading: Icon(
              user.isAdmin ? Icons.home : Icons.home,
              size: 30,
            ),
            title: user.isAdmin
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
          if (!user.isAdmin)
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
                      user: user,
                    ),
                  ),
                );
              },
            ),
          if (!user.isAdmin)
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
          if (!user.isAdmin)
            ListTile(
              leading: const Icon(
                Icons.new_label,
                size: 30,
              ),
              title: const Text(
                'NOUVEAU',
              ),
              onTap: () {},
            ),
          if (!user.isAdmin)
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
          if (!user.isAdmin)
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
                  MaterialPageRoute(builder: ((context) => const HomePage())),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
