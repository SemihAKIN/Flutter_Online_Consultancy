import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/models/profile.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/conversation_model.dart';
import '../locater.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServices _authServices = getIt<AuthServices>();

  Stream<List<Conversation>> getConversations(String userId) {
    var ref = _firestore
        .collection('conversations')
        .where('members', arrayContains: userId);

    Stream<QuerySnapshot<Map<String, dynamic>>> conversationsStream =
        ref.snapshots();
    Stream<List<Profile>> profilesStream = getContacts().asStream();

    return Rx.combineLatest2(
        conversationsStream,
        profilesStream,
        (QuerySnapshot conversations, List<Profile> profiles) =>
            conversations.docs.map((snapshot) {
              List<String> members = List.from(snapshot['members']);
              var profile = profiles.firstWhere((element) =>
                  element.id ==
                  members.firstWhere((member) => member != userId));
              return Conversation.fromSnapshot(snapshot, profile);
            }).toList());
  }

  Future<List<Profile>> getContacts() async {
    var partnerRef = _firestore.collection("Partner");
    var memberRef = _firestore.collection("Member");
    var partnerProfiles = await partnerRef.get();
    var memberProfiles = await memberRef.get();
    List<Profile> partnerProfilesList = partnerProfiles.docs
        .map((snapshot) => Profile.fromSnapshot(snapshot))
        .toList();
    List<Profile> memberProfilesList = memberProfiles.docs
        .map((snapshot) => Profile.fromSnapshot(snapshot))
        .toList();
    return (partnerProfilesList + memberProfilesList);
  }

  /// Check If Document Exists
  conversationExists(String userId, String senderId, Profile profile) async {
    try {
      List<List<String>> validIDs = [
        [userId, senderId],
        [senderId, userId]
      ];

      // Get reference to Firestore collection
      var collectionRef = _firestore
          .collection('conversations')
          .where('members', whereIn: validIDs);

      var doc = await collectionRef.get();
      if (doc.docs.isNotEmpty) {
        return doc.docs
            .map((snapshot) => Conversation.fromSnapshot(snapshot, profile))
            .toList();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Conversation> startConversation(User user, Profile profile) async {
    var ref = _firestore.collection('conversations');

    var documentRef = await ref.add({
      "displayMessage": "",
      "members": [_authServices.currentUser!.uid, profile.id]
    });

    return Conversation(
      id: documentRef.id,
      name: profile.name,
      profileImage: profile.image,
      displayMessage: '',
    );
  }

  Future<Conversation> getConversation(
      String conversationId, String memberId) async {
    var profileSnapshot =
        await _firestore.collection('profile').doc(memberId).get();
    var profile = Profile.fromSnapshot(profileSnapshot);
    return Conversation(
        id: conversationId,
        name: profile.name,
        profileImage: profile.image,
        displayMessage: '');
  }
}
