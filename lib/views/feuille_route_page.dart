import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mrm/controllers/auth_controller.dart';
import 'package:mrm/models/tache_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class FeuilleDeRoutePage extends StatefulWidget {
  const FeuilleDeRoutePage({super.key});

  @override
  State<FeuilleDeRoutePage> createState() => _feuilleDeRouteState();
}

class _feuilleDeRouteState extends State<FeuilleDeRoutePage> {
  final CalendarController _controllerCalender = CalendarController();
  late int nbTaches = 0;
  List<TacheModel> tachesList = [];
  late TacheModel a;
  getTaches() async {
    final data = await FirebaseFirestore.instance
        .collection('Taches')
        .where('toUser', isEqualTo: Auth().currentUser!.uid)
        .where('isTraite', isEqualTo: true)
        .get();

    setState(() {
      tachesList =
          List.from(data.docs.map((doc) => TacheModel.fromSnapshot(doc)));
    });
  }

  @override
  void initState() {
    getTaches();
    super.initState();
    _controllerCalender.view = CalendarView.month;
  }

  @override
  void dispose() {
    super.dispose();
    _controllerCalender.dispose();
  }

  List<Object> routeList = [];

  String? _subjectText = '',
      _startTimeText = '',
      _endTimeText = '',
      _dateText = '',
      _timeDetails = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Feuille de route'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Month'),
                    onPressed: () =>
                        _controllerCalender.view = CalendarView.month,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Week'),
                    onPressed: () =>
                        _controllerCalender.view = CalendarView.week,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Day'),
                    onPressed: () {
                      setState(
                        () => _controllerCalender.view = CalendarView.day,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SfCalendar(
              view: CalendarView.month,
              controller: _controllerCalender,
              dataSource: _getCalendarDataSource(tachesList),
              allowedViews: const [
                CalendarView.month,
                CalendarView.week,
                CalendarView.day
              ],
              onViewChanged: ChangeSfCalenderView,
              onTap: (CalendarTapDetails details) {
                var content = '';
                Duration allDiffParJour =
                    Duration(days: 0, hours: 0, seconds: 0);
                for (var i = 0; i < tachesList.length; i++) {
                  a = tachesList[i];
                  final day = tachesList[i].dateDebut!.toDate().day;
                  final month = tachesList[i].dateDebut!.toDate().month;
                  final year = tachesList[i].dateDebut!.toDate().year;
                  if (details.date!.day == day &&
                      details.date!.month == month &&
                      details.date!.year == year) {
                    final Duration diffDate = tachesList[i]
                        .dateFin!
                        .toDate()
                        .difference(tachesList[i].dateDebut!.toDate());
                    allDiffParJour = allDiffParJour + diffDate;
                    print("date equivalent");
                    content = content +
                        tachesList[i].ref.toString() +
                        " " +
                        tachesList[i].title.toString() +
                        "\n" +
                        tachesList[i]
                            .dateFin!
                            .toDate()
                            .hour
                            .toString()
                            .padLeft(2, '0') +
                        "h" +
                        tachesList[i]
                            .dateFin!
                            .toDate()
                            .minute
                            .toString()
                            .padLeft(2, '0') +
                        "-" +
                        tachesList[i]
                            .dateDebut!
                            .toDate()
                            .hour
                            .toString()
                            .padLeft(2, '0') +
                        "h" +
                        tachesList[i]
                            .dateDebut!
                            .toDate()
                            .minute
                            .toString()
                            .padLeft(2, '0') +
                        "=" +
                        diffDate.inHours.toString().padLeft(2, '0') +
                        "h" +
                        (diffDate.inMinutes % 60).toString().padLeft(2, '0') +
                        "\n\n";
                  } else {
                    print("date non equivalent");
                  }
                }

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    content = content +
                        "\n\nTotal Heure: " +
                        allDiffParJour.inHours.toString().padLeft(2, '0') +
                        "h" +
                        (allDiffParJour.inMinutes % 60)
                            .toString()
                            .padLeft(2, '0');
                    return AlertDialog(
                      title: const Text("Heures de travail"),
                      content: Text("Les heures de travail pour le jour "
                          "${details.date!.day}/${details.date!.month}/${details.date!.year}"
                          "\n\n\n${content}"),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Fermer"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ));
  }

  void ChangeSfCalenderView(ViewChangedDetails viewChangedDetails) {
    if (_controllerCalender.view == CalendarView.month) {
      _controllerCalender.view = CalendarView.month;
    }
    if (_controllerCalender.view == CalendarView.day) {
      _controllerCalender.view = CalendarView.day;
    }
    if (_controllerCalender.view == CalendarView.week) {
      _controllerCalender.view = CalendarView.week;
    }
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource(List<TacheModel> tache) {
  List<Appointment> appointments = <Appointment>[];
  TacheModel routeIndex;
  print(tache.length);
  for (var i = 0; i < tache.length; i++) {
    routeIndex = tache[i];
    print(routeIndex.dateDebut);
    Timestamp debut = routeIndex.dateDebut as Timestamp;
    Timestamp fin = routeIndex.dateFin as Timestamp;
    appointments.add(Appointment(
      startTime: debut.toDate(),
      endTime: fin.toDate(),
      isAllDay: true,
      subject: routeIndex.ref.toString(),
      notes: routeIndex.title,
      color: Colors.red,
      startTimeZone: '',
      endTimeZone: '',
    ));
  }

  return DataSource(appointments);
}
