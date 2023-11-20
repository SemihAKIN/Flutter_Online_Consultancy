import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/screens/chat/screens/member_meeting.dart';
import 'package:online_consultancy/screens/login_register/login.dart';

import '../core/locater.dart';
import '../core/services/navigator_services.dart';
import 'Drawer.dart';
import 'chat/screens/list_partners.dart';
import 'chat/screens/member_waiting_meeting_page.dart';
import 'chat/screens/valid_meeting_list_page.dart';
import 'chat/screens/validation_meeting.dart';

class Bolumler extends StatefulWidget {
  const Bolumler({super.key});

  @override
  State<Bolumler> createState() => _BolumlerState();
}

class _BolumlerState extends State<Bolumler> {
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final AuthServices _authService = getIt<AuthServices>();
  late String userType = "";
  String backgroundImage = "assets/register.png";
  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await _getUserType();
  }

  Future<void> _getUserType() async {
    userType = await _authService.userType(id: _authService.currentUser!.uid);
    setState(() {});
  }

  // TO DO
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Bolumlerimiz"),
          actions: [
            IconButton(
                onPressed: () {
                  _authService.signOut();
                  _navigatorService.navigateTo(const MyLogin());
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),

        //! Aşağıdaki fonksiyon sadece Partner olanlarda çalışacak
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            userType == "Member"
                ? FloatingActionButton(
                    heroTag: "listbtn",
                    onPressed: () {
                      _navigatorService.navigateTo(MemberMeetingListPage());
                    },
                    child: const Icon(Icons.list),
                  )
                : const SizedBox(),
            _emptyBox(),
            userType == "Member"
                ? FloatingActionButton(
                    heroTag: "searchbtn",
                    onPressed: () {
                      _navigatorService
                          .navigateTo(MemberWaitingMeetingListPage());
                    },
                    child: const Icon(Icons.zoom_in),
                  )
                : const SizedBox(),
            userType == "Partner"
                ? FloatingActionButton(
                    heroTag: "waitingMeetingBtn",
                    onPressed: () {
                      _navigatorService
                          .navigateTo(const ValidationMeetingPage());
                    },
                    child: const Icon(Icons.date_range_rounded),
                  )
                : const SizedBox(),
            _emptyBox(),
            userType == "Partner"
                ? FloatingActionButton(
                    heroTag: "acceptedMeetingBtn",
                    onPressed: () {
                      _navigatorService.navigateTo(ValidMeetingListPage());
                    },
                    child: const Icon(Icons.check),
                  )
                : const SizedBox(),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(backgroundImage), fit: BoxFit.cover)),
          child: Center(
            child: Stack(children: [
              SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin:
                                    const EdgeInsets.only(left: 35, right: 35),
                                child: Column(children: [
                                  _CustomContainer(
                                      onTap: () {
                                        _navigatorService.navigateTo(
                                            const ListJobPage(
                                                job: "Diyetisyen"));
                                      },
                                      img: "assets/diyetisyen.jpg",
                                      job: "Diyetisyen",
                                      detail: "...",
                                      price: "AYLIK / 200TL"),
                                  _emptyBox(),
                                  _CustomContainer(
                                      onTap: () {
                                        _navigatorService.navigateTo(
                                            const ListJobPage(
                                                job: "Psikolojik Danışman"));
                                      },
                                      img: "assets/psikoloji.jpg",
                                      job: "Psikoloji",
                                      detail: "...",
                                      price: "AYLIK / 300TL"),
                                  _emptyBox(),
                                  _CustomContainer(
                                      onTap: () {
                                        _navigatorService.navigateTo(
                                            const ListJobPage(
                                                job: "Kişisel Antrenör"));
                                      },
                                      img: "assets/fitness.webp",
                                      job: "Fitness Antrenor",
                                      detail: "...",
                                      price: "AYLIK / 100TL"),
                                ])),
                          ]))),
            ]),
          ),
        ));
  }
}

class _emptyBox extends StatelessWidget {
  const _emptyBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
    );
  }
}

class _CustomContainer extends StatelessWidget {
  _CustomContainer({
    Key? key,
    required this.img,
    required this.job,
    required this.detail,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  final String img;
  final String job;
  final String detail;
  final String price;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        height: 270,
        decoration: _BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                child: Image.asset(img, height: 150),
              ),
              Text(job,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(detail,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.normal)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(price,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  const Icon(Icons.app_registration_outlined,
                      color: Colors.red, size: 28),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _BoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 3)),
      ],
    );
  }
}
