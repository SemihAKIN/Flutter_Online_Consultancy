import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_consultancy/core/services/auth_service.dart';

import '../core/locater.dart';
import '../core/services/navigator_services.dart';

abstract class BaseModel with ChangeNotifier {
  final AuthServices authService = getIt<AuthServices>();

  final NavigatorService navigatorService = getIt<NavigatorService>();
  bool _busy = false;

  bool get busy => _busy;

  set busy(bool state) {
    _busy = state;

    notifyListeners();
  }

  User? get currentUser => authService.currentUser;

  void goBack() {
    navigatorService.pop();
  }
}
