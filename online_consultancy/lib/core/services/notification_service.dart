import 'package:firebase_messaging/firebase_messaging.dart';

import '../../screens/chat/screens/conversation_page.dart';
import '../locater.dart';
import 'chat_service.dart';
import 'navigator_services.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NavigatorService _navigatorService = getIt<NavigatorService>();
  final ChatService _chatService = getIt<ChatService>();

  NotificationService() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationClicked(message.data);
    });
  }
  Future<void> userNotificationPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future _notificationClicked(Map<String, dynamic> message) async {
    var data = message['data'];
    var conversation = await _chatService.getConversation(data['conversationId'], data['userId']);
    await _navigatorService.navigateTo(ConversationPage(conversation: conversation));
  }

  Future<String?> getUserToken() {
    return _messaging.getToken();
  }
}
