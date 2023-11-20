import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/models/detail_model.dart';
import 'package:online_consultancy/screens/chat/screens/partner_detail.dart';
import 'package:online_consultancy/screens/sections.dart';

import '../../../core/locater.dart';
import '../../../core/services/navigator_services.dart';

class ListJobPage extends StatelessWidget {
  final String job;
  const ListJobPage({super.key, required this.job});

  // TO DO
  // 1-) Textleri lang'a yazıp oradan çekme
  // 2-) Değişkenlerin İsimlerini değiştirme
  // 3-) Giriş yaptıktan sonra main_page.dart yerine bu sayfaya yönlendirme fakat çıkış butonu vs. dahil etme
  // 4-) Bu Container'ları basılır hale getirme ve bastığın anda basılan user_id ve diğer bilgilerini danismanlar.dart dosyasına aktarma

  @override
  Widget build(BuildContext context) {
    final NavigatorService _navigatorService = getIt<NavigatorService>();
    final AuthServices _authService = getIt<AuthServices>();
    String backgroundImage = "assets/register.png";
    return Scaffold(
      appBar: AppBar(
        title: Text(job),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            _navigatorService.navigateAndRemove(Bolumler());
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage), fit: BoxFit.cover)),
        child: StreamBuilder(
          stream:
              _authService.getFirestore.collection('PartnerDetail').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs
                  .where((element) => element['job'] == job)
                  .map((data) {
                return Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 192, 180, 180).withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          _navigatorService.navigateTo(PartnerDetailPage(
                              partnerDetail: PartnerDetail.fromSnapshot(data),
                              job: job));
                        },
                        title: Text(data['job']),
                        subtitle: Text(data['detail']),
                        trailing: Icon(
                          Icons.arrow_right_outlined,
                          size: 40,
                        ),
                      ),
                      Text(
                          "-------------------------------------------------------------------")
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
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
        height: 250,
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
              ),
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
