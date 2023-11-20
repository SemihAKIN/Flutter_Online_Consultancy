//Kullanıcının aldığı ve onaylanmayı bekleyen randevuları listelenen sayfa
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';

import '../../../core/locater.dart';
import '../../../core/services/meeting_service.dart';
import '../../../models/meeting_model.dart';

class MemberWaitingMeetingListPage extends StatelessWidget {
  MemberWaitingMeetingListPage({Key? key}) : super(key: key);
  final MeetingService _meetingService = getIt<MeetingService>();
  final AuthServices _authServices = getIt<AuthServices>();

  @override
  Widget build(BuildContext context) {
    String backgroundImage = "assets/register.png";
    return StreamBuilder(
      stream: _meetingService.getMeetings(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Onay Bekleen Toplantilar"),
          ),
          body: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(backgroundImage), fit: BoxFit.cover)),
            child: ListView(
              children: snapshot.data!.docs
                  .where((element) =>
                      element['interviewedId'] ==
                          _authServices.currentUser!.uid &&
                      element['requestStatus'] == "waiting" &&
                      element['endTime'].toDate().compareTo(DateTime.now()) ==
                          1)
                  .map((data) {
                MeetingInformation _meeting =
                    MeetingInformation.fromSnapshot(data);
                return ListTile(
                  title: Text(_meeting.meetingTopic ?? "Boş"),
                  subtitle: Text(
                      "${_meeting.startTime == null ? "Başlangıç Bilgisi Girilmemiş" : _meeting.startTime!.toDate()} - ${_meeting.endTime == null ? "Başlangıç Bilgisi Girilmemiş" : _meeting.endTime!.toDate()}"),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
