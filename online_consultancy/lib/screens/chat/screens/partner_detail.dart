// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/models/conversation_model.dart';
import 'package:online_consultancy/models/detail_model.dart';
import 'package:online_consultancy/models/profile.dart';
import 'package:online_consultancy/screens/chat/chat_main.dart';
import 'package:online_consultancy/screens/chat/screens/chats_page.dart';
import 'package:online_consultancy/screens/chat/screens/conversation_page.dart';
import 'package:online_consultancy/screens/chat/screens/dates_widget.dart';
import 'package:online_consultancy/screens/chat/screens/list_partners.dart';

import '../../../core/locater.dart';
import '../../../core/services/chat_service.dart';
import '../../../core/services/navigator_services.dart';

class PartnerDetailPage extends StatefulWidget {
  final PartnerDetail partnerDetail;

  final String job;

  const PartnerDetailPage(
      {Key? key, required this.partnerDetail, required this.job})
      : super(key: key);

  @override
  State<PartnerDetailPage> createState() => _PartnerDetailPageState();
}

class _PartnerDetailPageState extends State<PartnerDetailPage> {
  final ChatService _chatService = getIt<ChatService>();
  final AuthServices _authService = getIt<AuthServices>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    String backgroundImage = "assets/register.png";
    String ProfileImage = "assets/fitness.webp";

    var _navigatorService = getIt<NavigatorService>();

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Partner')
          .doc(widget.partnerDetail.id)
          .snapshots(),
      builder: (context, snapshot) => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                _navigatorService.navigateAndRemove(ListJobPage(
                  job: widget.job,
                ));
              },
              icon: Icon(Icons.arrow_back_outlined)),
          title: const Text('Danışanın Detayları'),
          actions: [
            IconButton(
              onPressed: () {
                _navigatorService.navigateTo(ChatsPage());
              },
              icon: Icon(Icons.wallet),
            ),
            IconButton(
              onPressed: () {
                _navigatorService.navigateTo(const ChatMain());
              },
              icon: Icon(Icons.mail_lock),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _ImageProfil(ProfileImage: ProfileImage),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 25),
                    child: SingleChildScrollView(
                      child: Container(
                        child: Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: _BaslikColumn(
                                    'AreasExpert',
                                    widget.partnerDetail.areasOfExpertise ??
                                        "Boş"),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: _BaslikColumn('Certificaties',
                                    widget.partnerDetail.certificates ?? "Boş"),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: _BaslikColumn('Detail',
                                    widget.partnerDetail.detail ?? "Boş"),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: _BaslikColumn('Education',
                                    widget.partnerDetail.education ?? "Boş"),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: _BaslikColumn(
                                    'Job', widget.partnerDetail.job ?? "Boş"),
                              ),
                              Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5)),
                                child: _BaslikColumn('Price',
                                    widget.partnerDetail.price ?? "Boş"),
                              ),
                              Spacer(),
                              ElevatedButton(
                                  onPressed: () {
                                    if (widget.partnerDetail.id == null) {
                                      return null;
                                    } else {
                                      if (_authService
                                          .currentUser!.emailVerified) {
                                        _navigatorService.navigateTo(
                                            DatesWidget(
                                                interviewerId:
                                                    widget.partnerDetail.id!));
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "E-posta doğrulanmadı"),
                                              content: const Text(
                                                  "Lütfen e-posta adresinizi doğrulayın."),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Tamam"),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: const Text("Randevu Al")),
                              // _BaslikColumn('TagList', widget.partnerDetail.tagList ?? []),
                              Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Profile profile = Profile(
                  id: widget.partnerDetail.id!,
                  image: snapshot.data!['photoUrl'].toString(),
                  name:
                      "${snapshot.data!['name']} ${snapshot.data!['surName']}");
              List<Conversation>? con = await _chatService.conversationExists(
                  _authService.currentUser!.uid,
                  widget.partnerDetail.id!,
                  profile);

              if (con == null) {
                Conversation conversation = await _chatService
                    .startConversation(_authService.currentUser!, profile);
                _navigatorService
                    .navigateTo(ConversationPage(conversation: conversation));
              } else {
                _navigatorService
                    .navigateTo(ConversationPage(conversation: con[0]));
              }
            },
            child: const Icon(Icons.message)),
      ),
    );
  }
}

Column _BaslikColumn(
  String _Baslik,
  String _BaslikCevap,
) {
  return Column(
    children: [
      Text(
        (_Baslik),
        style: BaslisStyle(),
      ),
      Text((_BaslikCevap), style: ParagrafStyle()),
    ],
  );
}

SizedBox Spacer() {
  return SizedBox(
    child: Text('-------------------------'),
  );
}

TextStyle ParagrafStyle() {
  return TextStyle(fontStyle: FontStyle.italic, fontSize: 18);
}

TextStyle BaslisStyle() {
  return TextStyle(
      fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 18);
}

class _ImageProfil extends StatelessWidget {
  const _ImageProfil({
    Key? key,
    required this.ProfileImage,
  }) : super(key: key);

  final String ProfileImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 150.0,
      width: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        //set border radius to 50% of square height and width
        image: DecorationImage(
          image: AssetImage(ProfileImage),
          fit: BoxFit.cover, //change image fill type
        ),
      ),
    );
  }
}
