import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String id;
  String name;
  String image;

  Profile({required this.id, required this.image, required this.name});
  factory Profile.fromSnapshot(DocumentSnapshot snapshot) {
    return Profile(id: snapshot.id, image: snapshot.get("photoUrl"), name: snapshot.get('name'));
  }
}
