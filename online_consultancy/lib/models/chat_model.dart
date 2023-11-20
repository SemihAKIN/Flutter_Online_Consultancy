// TO DO
// 1-) Bu görüşmelerde kullanılan bilgilerin modellenmesi
// 2-) Bu modellerin firestorage'a alınıp verilmesi işlemleri

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:online_consultancy/core/services/chat_service.dart';
import 'package:online_consultancy/models/conversation_model.dart';

class ChatsModel with ChangeNotifier {
  final ChatService _db = GetIt.instance<ChatService>();

  Stream<List<Conversation>> conversations(String userId) {
    return _db.getConversations(userId);
  }
}
