import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gere_Tache/update-tache.dart';
import 'package:mrm/views/Admin/Gerer_User/list_user_page.dart';
import 'package:mrm/views/Admin/navigation_admin.dart';
import 'package:toggle_switch/toggle_switch.dart';

class UpdateUserPage extends StatefulWidget {
  final UserModel users;
  final UserModel currentUser;
  UpdateUserPage({Key? key, required this.users, required this.currentUser});

  @override
  State<UpdateUserPage> createState() => _updateUserState();
}

class _updateUserState extends State<UpdateUserPage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  final userState = GlobalKey<FormFieldState>();
  int _isAdmin = 1;
  bool isAdmin = false;
  String ref = '';
  @override
  void initState() {
    super.initState();
    nameController.text = widget.users.name.toString();
    if (widget.users.isAdmin) {
      _isAdmin = 0;
      isAdmin = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('update User'),
      ),
      drawer: NavigationDrawerAdmin(user: widget.currentUser),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Update User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: nameController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Name'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (widget.users.isAdmin)
                    const Text(
                      'Admin',
                    ),
                  if (!widget.users.isAdmin)
                    const Text(
                      "Simple User",
                    ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text("Is Admin"),
                  const SizedBox(
                    height: 10,
                  ),
                  ToggleSwitch(
                    minWidth: 90.0,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [Colors.green[800]!],
                      [Colors.red[800]!]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    initialLabelIndex: _isAdmin,
                    totalSwitches: 2,
                    labels: ['True', 'False'],
                    radiusStyle: true,
                    onToggle: (index) {
                      setState(() {
                        _isAdmin = index!;
                        if (index == 0) {
                          isAdmin = true;
                        } else {
                          isAdmin = false;
                        }
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(widget.users.id)
                          .update({
                        'isAdmin': isAdmin,
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FetchUserViewAdmin(
                            user: widget.currentUser,
                          ),
                        ),
                      );
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
                    child: const Text('Confirme'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
