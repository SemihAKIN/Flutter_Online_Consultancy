//Kullanıcının aldığı ve onaylanan randevuları listelenen sayfa
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';

import '../../../core/locater.dart';
import '../../../core/services/meeting_service.dart';
import '../../../models/meeting_model.dart';
import 'meeting_start_page.dart';

class MemberMeetingListPage extends StatelessWidget {
  MemberMeetingListPage({Key? key}) : super(key: key);
  final MeetingService _meetingService = getIt<MeetingService>();
  final AuthServices _authServices = getIt<AuthServices>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();

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
            title: Text("Toplantilariniz"),
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
                      element['requestStatus'] == "accepted" &&
                      element['endTime'].toDate().compareTo(DateTime.now()) ==
                          1)
                  .map((data) {
                MeetingInformation _meeting =
                    MeetingInformation.fromSnapshot(data);
                return ListTile(
                  trailing: ElevatedButton(
                      onPressed: () async {
                        _navigatorService.navigateTo(MeetingStartPage(
                            meetingId: data.id, userType: "Member"));
                      },
                      child: const Text("Toplantıya Katıl")),
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
