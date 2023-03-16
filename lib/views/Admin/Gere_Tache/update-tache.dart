import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gere_Tache/list_tache_page.dart';
import 'package:mrm/views/Admin/navigation_admin.dart';

class UpdateTachePage extends StatefulWidget {
  final TacheModel tache;
  final UserModel user;
  UpdateTachePage({Key? key, required this.tache, required this.user});

  @override
  State<UpdateTachePage> createState() => _updateTacheState();
}

class _updateTacheState extends State<UpdateTachePage> {
  final formKey = GlobalKey<FormState>();

  TextEditingController refController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  final userState = GlobalKey<FormFieldState>();

  String ref = '';

  List<UserModel> userList = [];
  List<String> items = [];
  late UserModel actuelUsers = new UserModel(
      name: '', email: '', telephone: '', isAdmin: false, docId: '');
  String dropdownvalue = 'Update User';
  List<DrowElement> valeus = [];
  DrowElement d = new DrowElement('', '');

  getUser() async {
    final actuelUser =
        await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      userList =
          List.from(actuelUser.docs.map((doc) => UserModel.fromSnapshot(doc)));
      for (var i = 0; i < userList.length; i++) {
        if (widget.tache.toUser.toString() == userList[i].id.toString()) {
          actuelUsers = userList[i];
        }
        d = new DrowElement(userList[i].name, userList[i].id.toString());
        valeus.add(d);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
    refController.text = widget.tache.ref.toString();
    titleController.text = widget.tache.title.toString();
    valeus = [new DrowElement('Update User', 'Update User')];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('update tache'),
      ),
      drawer: NavigationDrawerAdmin(user: widget.user),
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
                    'Update Tache in Firebase storage',
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
                    controller: refController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'Ref'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: 'title'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    /*validator: (valeu) =>
                        valeu != null ? 'Entre a valid ref' : null,*/
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text("actuelle user :" + actuelUsers.name),
                  const SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: valeus.map((DrowElement item) {
                      return DropdownMenuItem(
                        value: item.valeu,
                        child: Text(item.item),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Taches")
                          .doc(widget.tache.id)
                          .update({'toUser': dropdownvalue});
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FetchTachesViewAdmin(
                                user: widget.user,
                              )));
                    },
                    child: const Text('Update Tache'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
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

class DrowElement {
  String valeu;
  String item;
  DrowElement(this.item, this.valeu);
  Map<String, dynamic> toJson() => {
        'valeu': valeu,
        'item': item,
      };
}
