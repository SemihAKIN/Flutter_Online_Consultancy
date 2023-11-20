// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../core/locater.dart';
import 'event_editing_page.dart';

class DatesWidget extends StatefulWidget {
  String interviewerId;
  DatesWidget({Key? key, required this.interviewerId}) : super(key: key);

  @override
  State<DatesWidget> createState() => _DatesWidgetState();
}

class _DatesWidgetState extends State<DatesWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  late final CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection("MeetingInformation").snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          List<Appointment> appointments = snapshot.data!.docs
              .where((element) =>
                  element['interviewerId'] == widget.interviewerId &&
                  element['endTime'].toDate().compareTo(DateTime.now()) == 1 &&
                  element['requestStatus'] == "accepted")
              .map((data) {
            return Appointment(
                startTime: data['startTime'] != null
                    ? data['startTime'].toDate()
                    : DateTime(2018, 2, 2, 2, 2),
                endTime: data['endTime'] != null
                    ? data['endTime'].toDate()
                    : DateTime(2018, 2, 2, 2, 2),
                color: Colors.grey.withOpacity(0.2),
                subject: 'Dolu');
          }).toList();

          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (_calendarController.selectedDate == null) {
                    _navigatorService.navigateTo(EventEditingPage(
                        dateTime: DateTime.now(),
                        interviewerId: widget.interviewerId));
                  } else {
                    print(_calendarController.selectedDate);
                    _navigatorService.navigateTo(EventEditingPage(
                        dateTime: _calendarController.selectedDate,
                        interviewerId: widget.interviewerId));
                  }
                },
                child: const Icon(Icons.add)),
            body: SfCalendar(
              view: CalendarView.week,
              //specialRegions: regions,
              controller: _calendarController,
              allowedViews: const [
                CalendarView.month,
                CalendarView.timelineMonth,
              ],
              minDate: DateTime.now(),
              dataSource:
                  DataSource(appointments)._getCalendarDataSource(appointments),
            ),
          );
        });
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }

  DataSource _getCalendarDataSource(List<Appointment> appointments) {
    return DataSource(appointments);
  }

  DataSource _addCalendarDataSource(
      {required DateTime startTime,
      required DateTime endTime,
      required Color color,
      required String subject}) {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: subject,
      color: color,
      startTimeZone: '',
      endTimeZone: '',
    ));

    return DataSource(appointments);
  }
}
