// ignore_for_file: public_member_api_docs, sort_constructors_first
//TO DO
// 1-) Danışmanlar ve danışanların girdiği bilgilere göre modeller oluşturma
// 2-) Bu modellerin servislerde kullanılabilir hale getirme.
// 3-) Oluşturulan bu model veya model listesini fire storage'da tutma ve çekme işlemleri

import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String? id;
  String? name;
  String? surName;
  String? email;
  String? city;
  String? photoUrl;
  Member({this.id, this.name, this.surName, this.email, this.city, this.photoUrl});

  factory Member.fromSnapshot(DocumentSnapshot snapshot) {
    return Member(
      id: snapshot.id,
      name: snapshot.get('name'),
      surName: snapshot.get('surName'),
      email: snapshot.get('email'),
      city: snapshot.get('city'),
      photoUrl: snapshot.get('photoUrl'),
    );
  }
}

class Partner {
  String? id;
  String? name;
  String? surName;
  String? email;
  String? city;
  String? photoUrl;
  String? address;
  String? phoneNumber;
  String? officePhoneNumber;
  String? officeName;
  Partner({
    this.id,
    this.name,
    this.surName,
    this.email,
    this.city,
    this.photoUrl,
    this.address,
    this.phoneNumber,
    this.officePhoneNumber,
    this.officeName,
  }) : super();

  factory Partner.fromSnapshot(DocumentSnapshot snapshot) {
    return Partner(
      id: snapshot.id,
      name: snapshot.get('name'),
      surName: snapshot.get('surName'),
      email: snapshot.get('email'),
      city: snapshot.get('city'),
      photoUrl: snapshot.get('photoUrl'),
      address: snapshot.get('address'),
      phoneNumber: snapshot.get('phoneNumber'),
      officePhoneNumber: snapshot.get('officePhoneNumber'),
      officeName: snapshot.get('officeName'),
    );
  }
}
