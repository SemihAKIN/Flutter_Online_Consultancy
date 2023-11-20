import 'package:online_consultancy/core/services/chat_service.dart';
import 'package:online_consultancy/models/profile.dart';
import 'package:online_consultancy/screens/chat/screens/conversation_page.dart';
import 'package:online_consultancy/viewmodels/base_model.dart';

import '../core/locater.dart';

class ContactsModel extends BaseModel {
  final ChatService _chatService = getIt<ChatService>();
  Future<List<Profile>> getContacts(String? query) async {
    var contacts = await _chatService.getContacts();
    var filteredContacts = contacts
        .where(
          (profile) => profile.name.startsWith(query ?? ""),
        )
        .toList();

    return filteredContacts;
  }

  Future<void> startConversation(Profile profile) async {
    var conversation =
        await _chatService.startConversation(currentUser!, profile);

    navigatorService.navigateTo(ConversationPage(conversation: conversation));
  }
}
