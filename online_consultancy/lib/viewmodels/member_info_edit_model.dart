import 'package:online_consultancy/viewmodels/base_model.dart';
import 'package:online_consultancy/viewmodels/register_model.dart';

import '../core/locater.dart';
import '../core/services/auth_service.dart';
import '../core/services/user_info_service.dart';
import '../models/auth_model.dart';

class MemberInfoModel extends BaseModel {
  RegisterModel registerModel = getIt<RegisterModel>();
  final UserInfoService _userService = getIt<UserInfoService>();
  final AuthServices _authService = getIt<AuthServices>();

  void notifyWidget() {
    notifyListeners();
  }

  Future<Member> getMemberData() async {
    busy = true;

    Member member =
        await _userService.getMember(memberId: _authService.currentUser!.uid);
    busy = false;

    return member;
  }

  Future<void> updateMemberInfo({required Member member}) async {
    _userService.setMember(member: member);
  }
}
