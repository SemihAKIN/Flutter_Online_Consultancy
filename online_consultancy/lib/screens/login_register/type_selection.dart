import 'package:flutter/material.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/screens/login_register/register_business_partner.dart';
import 'package:online_consultancy/screens/login_register/register_member.dart';

class TypeSelection extends StatelessWidget {
  const TypeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const TypeSelectionBody(),
      ),
    );
  }
}

class TypeSelectionBody extends StatelessWidget {
  const TypeSelectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 35, right: 35),
                  child: Column(
                    children: [_CustomBustton(context)],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Center _CustomBustton(BuildContext context) {
    final NavigatorService navigatorService = getIt<NavigatorService>();
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ))),
            onPressed: () {
              navigatorService.navigateTo(const BusinessPartnerRegister());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: Text("Business Partner Register",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 18)),
            ),
          ),
          const _emptyBox(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ))),
            onPressed: () {
              navigatorService.navigateTo(const MemberRegister());
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, right: 30, left: 30),
              child: Text("Just Member Register",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 18)),
            ),
          ),
        ],
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
