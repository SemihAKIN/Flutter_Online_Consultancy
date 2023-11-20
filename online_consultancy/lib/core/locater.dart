import 'package:get_it/get_it.dart';
import 'package:online_consultancy/core/services/auth_service.dart';
import 'package:online_consultancy/core/services/chat_service.dart';
import 'package:online_consultancy/core/services/dates_service.dart';
import 'package:online_consultancy/core/services/meeting_service.dart';
import 'package:online_consultancy/core/services/navigator_services.dart';
import 'package:online_consultancy/core/services/notification_service.dart';
import 'package:online_consultancy/core/services/storage_service.dart';
import 'package:online_consultancy/core/services/user_info_service.dart';
import 'package:online_consultancy/core/services/video_call_service.dart';
import 'package:online_consultancy/models/chat_model.dart';
import 'package:online_consultancy/viewmodels/conversation_model.dart';
import 'package:online_consultancy/viewmodels/main_model.dart';
import 'package:online_consultancy/viewmodels/register_model.dart';

import '../viewmodels/contacts_model.dart';
import '../viewmodels/login_model.dart';
import '../viewmodels/member_info_edit_model.dart';
import '../viewmodels/partner_info_edit_model.dart';

GetIt getIt = GetIt.instance;

setupLocater() {
  getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerLazySingleton(() => AuthServices());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => UserInfoService());
  getIt.registerLazySingleton(() => NotificationService());
  getIt.registerLazySingleton(() => DateService());
  getIt.registerLazySingleton(() => MeetingService());
  getIt.registerLazySingleton(() => VideoCallService());

  getIt.registerFactory(() => MainModel());
  getIt.registerFactory(() => LoginModel());
  getIt.registerFactory(() => ChatsModel());
  getIt.registerFactory(() => ContactsModel());
  getIt.registerFactory(() => ConversationModel());
  getIt.registerFactory(() => RegisterModel());
  getIt.registerFactory(() => PartnerInfoModel());
  getIt.registerFactory(() => MemberInfoModel());
}
