import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/meeting_service.dart';
import 'package:online_consultancy/models/meeting_model.dart';

import '../../../core/locater.dart';

class ValidationMeetingPage extends StatefulWidget {
  const ValidationMeetingPage({super.key});

  @override
  State<ValidationMeetingPage> createState() => _ValidationMeetingPageState();
}

class _ValidationMeetingPageState extends State<ValidationMeetingPage> {
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
              title: Text("Onay Bekleyen Toplantilar"),
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(backgroundImage), fit: BoxFit.cover)),
              child: ListView(
                children: snapshot.data!.docs
                    .where((element) =>
                        element['interviewerId'] ==
                            _authServices.currentUser!.uid &&
                        element['requestStatus'] == "waiting")
                    .map((data) {
                  MeetingInformation _meeting =
                      MeetingInformation.fromSnapshot(data);
                  return Container(
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 192, 180, 180).withOpacity(0.1),
                    ),
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                _meetingService.acceptMeeting(
                                    meeting: _meeting);
                                setState(() {});
                              },
                              icon: const Icon(Icons.check)),
                          IconButton(
                              onPressed: () {
                                _meetingService.rejectMeeting(
                                    meeting: _meeting);
                                _meetingService.deleteMeeting(
                                    meeting: _meeting);
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear)),
                        ],
                      ),
                      title: Text(_meeting.meetingTopic ?? "Boş"),
                      subtitle: Text(
                          "${_meeting.startTime == null ? "Başlangıç Bilgisi Girilmemiş" : _meeting.startTime!.toDate()} - ${_meeting.endTime == null ? "Başlangıç Bilgisi Girilmemiş" : _meeting.endTime!.toDate()}"),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
