import 'package:cloud_firestore/cloud_firestore.dart';

class DateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMeetingInformation({required String interviewerId}) {
    var ref = _firestore.collection("MeetingInformation").where('interviewerId', isEqualTo: interviewerId);

    //Boş dönerse ne olur bilmiyorum.
    return ref.snapshots();
  }

  String formatAppointment(DateTime startDate, DateTime endDate) {
    String timeFormatted =
        'Randevu Tarihi: ${startDate.day}/${startDate.month}/${startDate.year} \nRandevu Aralığı: ${startDate.hour}:${startDate.minute} - ${endDate.hour}:${endDate.minute}';

    return timeFormatted;
  }
}
