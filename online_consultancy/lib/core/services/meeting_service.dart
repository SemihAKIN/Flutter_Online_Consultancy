import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_consultancy/models/meeting_model.dart';

class MeetingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MeetingInformation> getMeeting({required meetingId}) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection("MeetingInformation").doc(meetingId).get();
    return MeetingInformation.fromSnapshot(snapshot);
  }

  void createMeeting({required MeetingInformation meeting}) async {
    _firestore.collection("MeetingInformation").add({
      "startTime": meeting.startTime,
      "endTime": meeting.endTime,
      "interviewerId": meeting.interviewerId,
      "interviewedId": meeting.interviewedId,
      "isMeeted": meeting.isMeeted,
      "meetingTopic": meeting.meetingTopic,
      "requestStatus": meeting.requestStatus,
      "code": meeting.code,
    });
  }

  void acceptMeeting({required MeetingInformation meeting}) {
    _firestore.collection("MeetingInformation").doc(meeting.id).set({
      "startTime": meeting.startTime,
      "endTime": meeting.endTime,
      "interviewerId": meeting.interviewerId,
      "interviewedId": meeting.interviewedId,
      "isMeeted": meeting.isMeeted,
      "meetingTopic": meeting.meetingTopic,
      "requestStatus": "accepted",
      "code": meeting.code,
    });
  }

  void rejectMeeting({required MeetingInformation meeting}) {
    _firestore.collection("MeetingInformation").doc(meeting.id).set({
      "startTime": meeting.startTime,
      "endTime": meeting.endTime,
      "interviewerId": meeting.interviewerId,
      "interviewedId": meeting.interviewedId,
      "isMeeted": meeting.isMeeted,
      "meetingTopic": meeting.meetingTopic,
      "requestStatus": "rejected",
      "code": meeting.code,
    });
  }

  void deleteMeeting({required MeetingInformation meeting}) {
    _firestore.collection("MeetingInformation").doc(meeting.id).delete();
  }

  getMeetings() {
    return _firestore
        .collection("MeetingInformation")
        .orderBy("startTime")
        .snapshots();
  }

  String generateRandomCode() {
    final random = Random();
    const codeLength = 6;
    final codeUnits = List.generate(
      codeLength,
      (index) => random.nextInt(10),
    );
    return codeUnits.join();
  }

  void updateMeetingStatus(
      {required MeetingInformation meeting, required bool isMeeted}) {
    _firestore.collection("MeetingInformation").doc(meeting.id).set({
      "startTime": meeting.startTime,
      "endTime": meeting.endTime,
      "interviewerId": meeting.interviewerId,
      "interviewedId": meeting.interviewedId,
      "isMeeted": isMeeted,
      "meetingTopic": meeting.meetingTopic,
      "requestStatus": meeting.requestStatus,
      "code": meeting.code,
    });
  }
}
