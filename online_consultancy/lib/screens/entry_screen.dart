import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/product/language/tr.dart';
import 'package:online_consultancy/screens/login_register/login.dart';
import 'package:online_consultancy/screens/sections.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/locater.dart';

class EntryScreen extends StatelessWidget {
  EntryScreen({super.key});

  String url = 'https://picsum.photos/200/300';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_BackgroundImage(url: url), const _EntryButtons()],
      ),
    );
  }
}

class _EntryButtons extends StatelessWidget {
  const _EntryButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          _CustomElevatedButton(content: TR.login),
        ]),
      ),
    );
  }
}

class _CustomElevatedButton extends StatelessWidget {
  _CustomElevatedButton({
    Key? key,
    required this.content,
  }) : super(key: key);
  String content;
  final AuthServices _authServices = getIt<AuthServices>();
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          )),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        if (email != null && password != null) {
          await _authServices.signInWithEmailAndPassword(
              email: email, password: password);
          _navigatorService.navigateTo(const Bolumler());
        } else {
          _navigatorService.navigateTo(const MyLogin());
        }
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, right: 30, left: 30),
        child: Text(content,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontSize: 18)),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
    );
  }
}
