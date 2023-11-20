import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_consultancy/models/detail_model.dart';

import '../../models/auth_model.dart';

class UserInfoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PartnerDetail> getPartnerDetail({required String partnerId}) async {
    var partnerDetail =
        await _firestore.collection('PartnerDetail').doc(partnerId).get();
    return PartnerDetail(
        id: partnerDetail.id,
        areasOfExpertise: partnerDetail['areasOfExpertise'],
        certificates: partnerDetail['certificates'],
        detail: partnerDetail['detail'],
        education: partnerDetail['education'],
        job: partnerDetail['job'],
        price: partnerDetail['price'],
        tagList: partnerDetail['tagList']);
  }

  Future<Partner> getPartner({required String partnerId}) async {
    var partner = await _firestore.collection('Partner').doc(partnerId).get();
    return Partner(
      id: partner.id,
      name: partner['name'],
      surName: partner['surName'],
      email: partner['email'],
      city: partner['city'],
      photoUrl: partner['photoUrl'],
      address: partner['address'],
      phoneNumber: partner['phoneNumber'],
      officePhoneNumber: partner['officePhoneNumber'],
      officeName: partner['officeName'],
    );
  }

  Future<Member> getMember({required String memberId}) async {
    var member = await _firestore.collection('Member').doc(memberId).get();
    return Member(
      id: member.id,
      name: member['name'],
      surName: member['surName'],
      email: member['email'],
      city: member['city'],
      photoUrl: member['photoUrl'],
    );
  }

  Future<void> setPartner({required Partner partner}) async {
    await _firestore.collection('Partner').doc(partner.id).update({
      'name': partner.name,
      'surName': partner.surName,
      'email': partner.email,
      'city': partner.city,
      'photoUrl': partner.photoUrl,
      'address': partner.address,
      'phoneNumber': partner.phoneNumber,
      'officePhoneNumber': partner.officePhoneNumber,
      'officeName': partner.officeName,
    });
  }

  Future<void> setPartnerDetail(
      {required String partnerId, required PartnerDetail partnerDetail}) async {
    await _firestore.collection('PartnerDetail').doc(partnerId).update({
      'areasOfExpertise': partnerDetail.areasOfExpertise,
      'certificates': partnerDetail.certificates,
      'detail': partnerDetail.detail,
      'education': partnerDetail.education,
      'job': partnerDetail.job,
      'price': partnerDetail.price,
      'tagList': partnerDetail.tagList,
    });
  }

  Future<void> setMember({required Member member}) async {
    await _firestore.collection('Member').doc(member.id).update({
      'name': member.name,
      'surName': member.surName,
      'email': member.email,
      'city': member.city,
      'photoUrl': member.photoUrl,
    });
  }
}
