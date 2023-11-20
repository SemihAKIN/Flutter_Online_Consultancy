//Randevu bilgileri alınan sayfa

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/models/meeting_model.dart';

import '../../../core/services/meeting_service.dart';

class EventEditingPage extends StatefulWidget {
  DateTime? dateTime;
  String interviewerId;
  EventEditingPage({
    Key? key,
    this.dateTime,
    required this.interviewerId,
  }) : super(key: key);

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final AuthServices _authService = getIt<AuthServices>();
  final MeetingService _meetingService = getIt<MeetingService>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  late GlobalKey<FormState> _formKey;
  late TextEditingController _topicController;
  bool isStartTimePicked = false;
  bool isEndTimePicked = false;
  final MeetingInformation _meetingInformation = MeetingInformation();
  //Buradan interviewedId'ye ulaşacağız
  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _topicController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _topicController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String backgroundImage = "assets/register.png";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Editing Page"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () {
          if (isStartTimePicked == true &&
              isEndTimePicked == true &&
              _formKey.currentState!.validate()) {
            _meetingInformation.interviewerId = widget.interviewerId;
            _meetingInformation.interviewedId = _authService.currentUser!.uid;
            _meetingInformation.isMeeted = false;
            _meetingInformation.requestStatus = "waiting";
            _meetingInformation.code = _meetingService.generateRandomCode();
            _meetingService.createMeeting(meeting: _meetingInformation);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Teşekkürler'),
                  content: const Text(
                      'Randevunuz oluşturuldu! Danışmanın onaylaması bekleniyor.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _navigatorService.pop();
                        _navigatorService.pop();
                      },
                      child: const Text('Tamam'),
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Eksik Bilgiler'),
                  content: const Text('Lütfen Eksik Bilgileri doldurun!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Tamam'),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _topicController,
                  validator: (value) {
                    if (value == "") {
                      return "Lütfen Konu giriniz.";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (topic) {
                    //Yazılan kaydedilir.
                    _meetingInformation.meetingTopic = topic;
                    //_topicController.text modele kaydedilir. En son model bekleyen statusunde veritabanına aktarılır.
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await selectTime(context);
                    if (pickedTime != null) {
                      isStartTimePicked = true;
                      widget.dateTime = widget.dateTime!
                          .subtract(Duration(
                              hours: widget.dateTime!.hour,
                              minutes: widget.dateTime!.minute))
                          .add(Duration(
                              hours: pickedTime.hour,
                              minutes: pickedTime.minute));

                      _meetingInformation.startTime =
                          Timestamp.fromDate(widget.dateTime!);
                      //Gerekli servis işlemleri yapılacak
                    }
                  },
                  child: const Text("Başlangıç"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await selectTime(context);
                    if (pickedTime != null) {
                      isEndTimePicked = true;
                      widget.dateTime = widget.dateTime!
                          .subtract(Duration(
                              hours: widget.dateTime!.hour,
                              minutes: widget.dateTime!.minute))
                          .add(Duration(
                              hours: pickedTime.hour,
                              minutes: pickedTime.minute));

                      _meetingInformation.endTime =
                          Timestamp.fromDate(widget.dateTime!);
                    } else {
                      print("pickedTime Boş");
                    }
                  },
                  child: const Text("Bitiş"),
                ),
              ],
            )),
      ),
    );
  }
}

Future<TimeOfDay?> selectTime(BuildContext context) async {
  TimeOfDay? selectedTime =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (selectedTime != null) {
    return selectedTime;
  } else {
    // Kullanıcı herhangi bir zaman seçmedi, uyarı göster
  }
}
