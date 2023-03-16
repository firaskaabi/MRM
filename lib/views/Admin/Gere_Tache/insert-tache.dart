import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrm/controllers/firestore_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/Admin/Gere_Tache/list_tache_page.dart';
import 'package:mrm/views/Admin/Gere_Tache/update-tache.dart';
import 'package:mrm/views/Admin/navigation_admin.dart';

class InsertTache extends StatefulWidget {
  final UserModel currentUser;
  const InsertTache({super.key, required this.currentUser});

  @override
  State<InsertTache> createState() => _InsertTacheState();
}

class _InsertTacheState extends State<InsertTache> {
  late List<UserModel> users = [];

  CollectionReference taches = FirebaseFirestore.instance.collection('Taches');
  final formKey = GlobalKey<FormState>();
  final refController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final createdByController = TextEditingController();
  final prenomController = TextEditingController();
  final userState = GlobalKey<FormFieldState>();

  String ref = '';

  List<UserModel> userList = [];
  List<String> items = [];
  late UserModel actuelUsers = new UserModel(
      name: '', email: '', telephone: '', isAdmin: false, docId: '');
  String dropdownvalue = 'Update User';
  List<DrowElement> valeus = [];
  DrowElement d = new DrowElement('', '');

  late String _selectedItem;

  String _selectedImportance = 'Select Importance';
  String _selectedUser = 'Select Utilisateur';

  getUser() async {
    final actuelUser =
        await FirebaseFirestore.instance.collection("users").get();
    setState(() {
      userList =
          List.from(actuelUser.docs.map((doc) => UserModel.fromSnapshot(doc)));
      for (var i = 0; i < userList.length; i++) {
        d = new DrowElement(userList[i].name, userList[i].id.toString());
        valeus.add(d);
      }
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
    valeus = [new DrowElement('Update User', 'Update User')];
  }

  @override
  void dispose() {
    refController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    createdByController.dispose();
    prenomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Taches'),
      ),
      drawer: NavigationDrawerAdmin(user: widget.currentUser),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Ajouter Nouvelle Tache ',
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
                    decoration: const InputDecoration(labelText: 'Ref'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Title'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Description'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: createdByController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'CreatedBy'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: prenomController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Teléphone'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    /*validator: (valeu) =>
                        valeu != null ? 'Entre a valid prenom' : null,*/
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedImportance,
                    items: <String>[
                      'Select Importance',
                      'Bas',
                      'Normal',
                      'Élevé',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      _selectedImportance = value.toString();
                    }),
                  ),
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
                      addTachesToUser();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => FetchTachesViewAdmin(
                                  user: widget.currentUser,
                                )),
                      );
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
                    child: const Text('Ajouter Taches'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addTachesToUser() {
    // ignore: unnecessary_new
    TacheModel tacheModel = new TacheModel(
        ref: refController.text.trim(),
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        createdBy: createdByController.text.trim(),
        importance: _selectedImportance,
        tel: prenomController.text.trim(),
        toUser: dropdownvalue,
        isTraite: false);
    Firestore.addTache(tacheModel);
  }
}

class Item {
  final String name;
  final String value;

  Item(this.name, this.value);
}
