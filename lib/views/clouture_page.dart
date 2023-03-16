import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:mrm/models/user_model.dart';
import 'package:mrm/views/NavigationDrawer.dart';
import 'package:mrm/views/arrive_page.dart';
import 'package:mrm/views/termine_tache_page.dart';

class ClotureTachePage extends StatefulWidget {
  late TacheModel tache;
  final UserModel user;

  ClotureTachePage({Key? key, required this.tache, required this.user})
      : super(key: key);
  @override
  State<ClotureTachePage> createState() => _ClotureTachePage();
}

class _ClotureTachePage extends State<ClotureTachePage> {
  Duration duration = Duration();
  Timer? timer;

  void addTime() {
    setState(() {
      final seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    const url =
        'https://www.solidbackgrounds.com/images/1920x1080/1920x1080-red-solid-color-background.jpg';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clouture  Taches"),
      ),
      drawer: NavigationDrawer(user: widget.user),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            if (widget.tache.importance == "Élevé")
              const SizedBox(
                height: 10.0,
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                ),
              ),
            if (widget.tache.importance == "Normal")
              const SizedBox(
                height: 10.0,
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.orange),
                ),
              ),
            if (widget.tache.importance == "Bas")
              const SizedBox(
                height: 10.0,
                width: 250,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ),
            Card(
              margin: const EdgeInsets.all(20.0),
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.greenAccent,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 15,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "${widget.tache.ref} ${widget.tache.title}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.tache.description.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.tache.createdBy.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "telphone :" + widget.tache.tel.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            buildTimer(),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(
                      Icons.check_box,
                      size: 32,
                    ),
                    label: const Text(
                      'Cloture',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      CloutureTache();
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Colors.red,
                    ),
                    icon: const Icon(
                      Icons.close,
                      size: 32,
                    ),
                    label: const Text(
                      'Annuler',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      annulerTache();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 40,
        ),
      );
  void annulerTache() async {
    FirebaseFirestore.instance
        .collection("Taches")
        .doc(widget.tache.id)
        .update({'dateDebut': FieldValue.delete()});
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ArriveTachePage(
                tache: widget.tache,
                user: widget.user,
              )),
    );
  }

  Future<void> CloutureTache() async {
    try {
      await FirebaseFirestore.instance
          .collection("Taches")
          .doc(widget.tache.id)
          .update({"dateFin": DateTime.now()});

      final data = await FirebaseFirestore.instance
          .collection("Taches")
          .doc(widget.tache.id)
          .get();
      setState(() {
        widget.tache = TacheModel.fromSnapshot(data);
      });
      print(widget.tache.dateDebut);
    } catch (e) {
      print('Erreur de mise à jour: $e');
    }
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => TermineTachePage(
                tache: widget.tache, user: widget.user, duree: duration)),
      );
    });
  }
}
