import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mrm/controllers/firestore_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/NavigationDrawer.dart';
import 'package:mrm/views/feuille_route_page.dart';

class TermineTachePage extends StatefulWidget {
  final TacheModel tache;
  final UserModel user;
  final Duration duree;

  const TermineTachePage(
      {Key? key, required this.tache, required this.user, required this.duree})
      : super(key: key);

  TacheModel get valTache => tache;
  @override
  State<TermineTachePage> createState() => _termineTachePage();
}

class _termineTachePage extends State<TermineTachePage> {
  Future<TacheModel>? initialTache;
  final _formKey = GlobalKey<FormState>();

  Duration duration = const Duration();
  final formKey = GlobalKey<FormState>();
  final remarqueController = TextEditingController();
  Timer? timer;
  late int hourDebut = 0;
  late int minutDebut = 0;
  late int hourFin = 0;
  late int minuteFin = 0;
  late TimeOfDay timeDebut;
  late TimeOfDay timeFin;
  String remarque = '';

  getTache() {
    initialTache = Firestore.getTache(widget.tache.id);
  }

  @override
  void initState() {
    hourDebut = widget.tache.dateDebut!.toDate().hour.toInt();
    minutDebut = widget.tache.dateDebut!.toDate().minute.toInt();
    hourFin =
        widget.tache.dateDebut!.toDate().hour.toInt() + widget.duree.inHours;

    minuteFin = widget.tache.dateDebut!.toDate().minute.toInt() +
        (widget.duree.inMinutes % 60);
    timeDebut = TimeOfDay(hour: hourDebut, minute: minutDebut);
    timeFin = TimeOfDay(hour: hourFin, minute: minuteFin);
    print(widget.duree.toString());
    super.initState();
  }

  @override
  void dispose() {
    remarqueController.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSecond = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecond;
      duration = Duration(seconds: seconds);
    });
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  Widget build(BuildContext context) {
    const url =
        'https://www.solidbackgrounds.com/images/1920x1080/1920x1080-red-solid-color-background.jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Termine Tache"),
      ),
      drawer: NavigationDrawer(user: widget.user),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Image.network(
            url,
            height: 10,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.greenAccent,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          widget.tache.ref.toString() +
                              " " +
                              widget.tache.title.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: remarqueController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    maxLines: 8,
                    minLines: 4,
                    decoration: const InputDecoration(labelText: 'Remarque'),
                    onChanged: (val) => setState(() {
                      remarque = val;
                    }),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "remarque shouldn't be empty";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blueAccent,
              ),
              label: Text(
                '${timeDebut.hour.toString().padLeft(2, '0')}:${timeDebut.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 40),
              ),
              icon: const Icon(
                Icons.timeline,
                size: 32,
              ),
              onPressed: () async {
                /*TimeOfDay? newDebutTimer = await showTimePicker(
                    context: context, initialTime: timeDebut);
                if (newDebutTimer == null) return;
                setState(() {
                  DateTime date = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      newDebutTimer.hour,
                      newDebutTimer.minute);
                  Timestamp timestamp = Timestamp.fromDate(date);
                  FirebaseFirestore.instance
                      .collection("Taches")
                      .doc(widget.tache.id)
                      .update({"dateDebut": timestamp});
                  timeDebut = newDebutTimer;
                  if (toDouble(timeDebut) > toDouble(timeFin))
                    timeFin = timeDebut;
                });*/
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blueAccent,
              ),
              label: Text(
                '${timeFin.hour.toString().padLeft(2, '0')}:${timeFin.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 40),
              ),
              icon: const Icon(
                Icons.timeline,
                size: 32,
              ),
              onPressed: () async {
                /*  if (toDouble(timeDebut) > toDouble(timeFin))
                  timeFin = timeDebut;
                TimeOfDay? newDebutTimer = await showTimePicker(
                    context: context, initialTime: timeFin);
                if (newDebutTimer == null) return;
                setState(() {
                  DateTime date = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      newDebutTimer.hour,
                      newDebutTimer.minute);
                  Timestamp timestamp = Timestamp.fromDate(date);
                  FirebaseFirestore.instance
                      .collection("Taches")
                      .doc(widget.tache.id)
                      .update({"dateFin": timestamp});
                  timeFin = newDebutTimer;
                  if (toDouble(timeDebut) > toDouble(timeFin))
                    timeFin = timeDebut;
                });*/
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Colors.green,
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 32,
                  ),
                  label: const Text(
                    'Envoyer',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      FirebaseFirestore.instance
                          .collection("Taches")
                          .doc(widget.tache.id)
                          .update({
                        'isTraite': true,
                        'remarque': remarqueController.text.trim()
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FeuilleDeRoutePage(),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimer() {
    String towDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = towDigits(duration.inMinutes.remainder(60));
    final seconds = towDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimerCard(time: minutes, header: 'Minutes'),
        const SizedBox(
          width: 8,
        ),
        buildTimerCard(time: seconds, header: 'Seconds'),
      ],
    );
  }

  Widget buildTimerCard({required String time, required String header}) => Text(
        time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 40,
        ),
      );
}
