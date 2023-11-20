import 'package:flutter/material.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  void pop() {
    _navigatorKey.currentState?.pop();
  }

  Future<dynamic>? navigateTo(Widget route) {
    return _navigatorKey.currentState?.push(MaterialPageRoute(builder: (BuildContext context) => route));
  }

  Future<dynamic>? navigateAndRemove(Widget route) {
    return _navigatorKey.currentState
        ?.pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => route), (route) => false);
  }

  Future<dynamic>? navigatewithName(String name) {
    return _navigatorKey.currentState?.pushNamed(name);
  }
}
