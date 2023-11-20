import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/dates_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';

import '../../../core/locater.dart';
import '../../../core/services/meeting_service.dart';
import '../../../models/meeting_model.dart';
import 'meeting_start_page.dart';

class ValidMeetingListPage extends StatelessWidget {
  ValidMeetingListPage({super.key});
  final MeetingService _meetingService = getIt<MeetingService>();
  final AuthServices _authServices = getIt<AuthServices>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final DateService _dateService = getIt<DateService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _meetingService.getMeetings(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text("Onaylanan Toplantilar"),
          ),
          body: ListView(
            children: snapshot.data!.docs
                .where((element) =>
                    element['interviewerId'] ==
                        _authServices.currentUser!.uid &&
                    element['requestStatus'] == "accepted" &&
                    element['endTime'].toDate().compareTo(DateTime.now()) == 1)
                .map((data) {
              MeetingInformation _meeting =
                  MeetingInformation.fromSnapshot(data);
              return ListTile(
                trailing: ElevatedButton(
                    onPressed: () async {
                      String userType = await _authServices.userType(
                          id: _authServices.currentUser!.uid);
                      _navigatorService.navigateTo(MeetingStartPage(
                          meetingId: data.id, userType: userType));
                    },
                    child: const Text("Toplantıyı Başlat")),
                title: Text(_meeting.meetingTopic ?? "Boş"),
                subtitle: Text(
                    _meeting.startTime == null && _meeting.endTime == null
                        ? "Tarih bilgileri girilmemiş!"
                        : _dateService.formatAppointment(
                            _meeting.startTime!.toDate(),
                            _meeting.endTime!.toDate())),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
