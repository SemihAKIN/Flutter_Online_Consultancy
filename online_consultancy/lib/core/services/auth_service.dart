import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_consultancy/models/auth_model.dart';
import 'package:online_consultancy/models/detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locater.dart';
import 'navigator_services.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _navigatorService = getIt<NavigatorService>();

  User? get currentUser => _auth.currentUser;
  get getFirestore => _firestore;

  signInWithEmailAndPassword({required email, required password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      return user.user;
    });
  }

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    return await _auth.signOut();
  }

  addDetailPartner({required PartnerDetail detail}) async {
    await _firestore.collection("PartnerDetail").doc(detail.id).set({
      'job': detail.job,
      'tagList': detail.tagList,
      'detail': detail.detail,
      'areasOfExpertise': detail.areasOfExpertise,
      'education': detail.education,
      'price': detail.price,
      'certificates': detail.certificates,
    });
  }

  createMember({required Member member, required password}) async {
    try {
      if (member.email != null) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: member.email!, password: password);
        await _firestore.collection("Member").doc(user.user!.uid).set({
          'name': member.name,
          'surName': member.surName,
          'email': member.email,
          'city': member.city,
          'photoUrl': member.photoUrl
        });

        return user.user;
      } else {
        Fluttertoast.showToast(msg: "Email Girilmedi!");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  createPartner({required Partner partner, required password}) async {
    try {
      if (partner.email != null) {
        var user = await _auth.createUserWithEmailAndPassword(
            email: partner.email!, password: password);
        await _firestore.collection("Partner").doc(user.user!.uid).set({
          'name': partner.name,
          'surName': partner.surName,
          'email': partner.email,
          'city': partner.city,
          'photoUrl': partner.photoUrl,
          'address': partner.address,
          'phoneNumber': partner.phoneNumber,
          'officePhoneNumber': partner.officePhoneNumber,
          'officeName': partner.officeName
        });
        return user.user;
      } else {
        Fluttertoast.showToast(msg: "Email Girilmedi!");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> userType({required String id}) async {
    final memberSnapshot =
        await FirebaseFirestore.instance.collection('Member').doc(id).get();
    if (memberSnapshot.exists) {
      return "Member";
    } else {
      return "Partner";
    }
  }
}
