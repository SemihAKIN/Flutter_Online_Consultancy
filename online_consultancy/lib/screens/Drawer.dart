import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/screens/Danisan_Profil_edit.dart';
import 'package:online_consultancy/screens/Partner_Profile_Edit.dart';

import '../core/locater.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final AuthServices _authService = getIt<AuthServices>();
  late String userType = "";

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_2_outlined,
                    size: 50,
                  ),
                  Text(
                    "Danismanim Flutter Proje",
                    style: TextStyle(color: Colors.white, fontSize: 30.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Kisisel Bilgileriniz"),
            trailing: Icon(Icons.arrow_right_outlined),
            onTap: () {
              if (userType == "Partner") {
                _navigatorService.navigateTo(PartnerProfileEdit());
              } else {
                _navigatorService.navigateTo(MemberProfileEdit());
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("-------"),
            trailing: Icon(Icons.arrow_right_outlined),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("-------"),
            trailing: Icon(Icons.arrow_right_outlined),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
