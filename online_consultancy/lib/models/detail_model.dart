import 'package:cloud_firestore/cloud_firestore.dart';

class PartnerDetail {
  String? id;
  String? job;
  List<dynamic>? tagList;
  String? detail;
  String? areasOfExpertise;
  String? education;
  String? certificates;
  String? price;
  PartnerDetail(
      {this.id, this.job, this.tagList, this.detail, this.areasOfExpertise, this.education, this.certificates, this.price});
  factory PartnerDetail.fromSnapshot(DocumentSnapshot snapshot) {
    return PartnerDetail(
      id: snapshot.id,
      job: snapshot.get('job'),
      areasOfExpertise: snapshot.get('areasOfExpertise'),
      certificates: snapshot.get('certificates'),
      detail: snapshot.get('detail'),
      education: snapshot.get('education'),
      tagList: snapshot.get('tagList'),
      price: snapshot.get('price'),
    );
  }
}
