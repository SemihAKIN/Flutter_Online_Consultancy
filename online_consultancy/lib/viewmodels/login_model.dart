import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/notification_service.dart';
import 'package:online_consultancy/viewmodels/base_model.dart';

class LoginModel extends BaseModel {
  final AuthServices _authService = getIt<AuthServices>();
  final NotificationService _notificationService = getIt<NotificationService>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> signIn(String email, String password) async {
    busy = true;

    try {
      User? user = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      _notificationService.userNotificationPermission();
      var token = await _notificationService.getUserToken();

      var profile = await _db
          .collection("Member")
          .doc(_authService.currentUser!.uid)
          .get();

      if (!profile.exists) {
        await _db
            .collection("Partner")
            .doc(_authService.currentUser!.uid)
            .update({'token': token});
      } else {
        await _db
            .collection("Member")
            .doc(_authService.currentUser!.uid)
            .update({'token': token});
      }
      busy = false;
      return 'valid';
    } on FirebaseAuthException catch (error) {
      busy = false;
      return error.code;
    }
  }
}
