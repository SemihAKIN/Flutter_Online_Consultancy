import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:online_consultancy/models/profile.dart';

class Conversation {
  String id;
  String name;
  String profileImage;
  String displayMessage;

  Conversation(
      {required this.displayMessage,
      required this.id,
      required this.name,
      required this.profileImage});
  factory Conversation.fromSnapshot(
      DocumentSnapshot snapshot, Profile profile) {
    return Conversation(
        id: snapshot.id,
        name: profile.name,
        profileImage: profile.image,
        displayMessage: snapshot.get('displayMessage'));
  }
}
