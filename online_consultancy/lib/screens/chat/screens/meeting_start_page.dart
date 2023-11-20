// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/meeting_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/core/services/video_call_service.dart';
import 'package:online_consultancy/models/meeting_model.dart';
import 'package:online_consultancy/screens/chat/screens/video_call.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/locater.dart';

class MeetingStartPage extends StatefulWidget {
  String meetingId;
  String userType;
  MeetingStartPage({Key? key, required this.meetingId, required this.userType})
      : super(key: key);

  @override
  State<MeetingStartPage> createState() => _MeetingStartPageState();
}

class _MeetingStartPageState extends State<MeetingStartPage> {
  late TextEditingController _codeController;
  bool _validateError = false;
  final MeetingService _meetingService = getIt<MeetingService>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final VideoCallService _videoCallService = getIt<VideoCallService>();
  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage = "assets/register.png";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Meeting"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Center(
            child: Column(
          children: [
            const Text(
                "Lütfen e-posta adresinize gelen toplantı kodunuzu girin"),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                errorText: _validateError ? 'Yanlış kod girdiniz' : null,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                MeetingInformation meetingInformation = await _meetingService
                    .getMeeting(meetingId: widget.meetingId);
                if (_codeController.text != meetingInformation.code) {
                  setState(() {
                    _validateError = true;
                  });
                } else {
                  _videoCallService.handleCameraAndMic(Permission.microphone);
                  _videoCallService.handleCameraAndMic(Permission.camera);
                  _videoCallService.handleCameraAndMic(Permission.bluetooth);
                  _meetingService.updateMeetingStatus(
                      meeting: meetingInformation, isMeeted: true);
                  _navigatorService.navigateTo(
                      VideoCallPage(channelName: _codeController.text));
                }
              },
              child: widget.userType == "Member"
                  ? const Text("Toplantıya Katıl")
                  : const Text("Toplantıyı Başlat"),
            ),
          ],
        )),
      ),
    );
  }
}
