// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingInformation {
  String? id;
  String? interviewerId;
  String? interviewedId;
  Timestamp? startTime;
  Timestamp? endTime;
  bool? isMeeted;
  String? meetingTopic;
  String? requestStatus;
  String? code;
  MeetingInformation({
    this.id,
    this.interviewerId,
    this.interviewedId,
    this.startTime,
    this.endTime,
    this.isMeeted,
    this.meetingTopic,
    this.requestStatus,
    this.code,
  });

  factory MeetingInformation.fromSnapshot(DocumentSnapshot snapshot) {
    return MeetingInformation(
      id: snapshot.id,
      interviewerId: snapshot.get("interviewerId"),
      interviewedId: snapshot.get("interviewedId"),
      startTime: snapshot.get("startTime"),
      endTime: snapshot.get("endTime"),
      isMeeted: snapshot.get("isMeeted"),
      meetingTopic: snapshot.get("meetingTopic"),
      requestStatus: snapshot.get("requestStatus"),
      code: snapshot.get('code'),
    );
  }
}
