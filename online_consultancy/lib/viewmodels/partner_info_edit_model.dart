import 'package:online_consultancy/models/detail_model.dart';
import 'package:online_consultancy/viewmodels/base_model.dart';
import 'package:online_consultancy/viewmodels/register_model.dart';

import '../core/locater.dart';
import '../core/services/auth_service.dart';
import '../core/services/user_info_service.dart';
import '../models/auth_model.dart';

class PartnerInfoModel extends BaseModel {
  RegisterModel registerModel = getIt<RegisterModel>();
  final UserInfoService _userService = getIt<UserInfoService>();
  final AuthServices _authService = getIt<AuthServices>();

  void notifyWidget() {
    notifyListeners();
  }

  Future<Partner> getPartnerData() async {
    busy = true;

    Partner partner =
        await _userService.getPartner(partnerId: _authService.currentUser!.uid);
    busy = false;

    return partner;
  }

  Future<PartnerDetail> getPartnerDetailData() async {
    busy = true;
    PartnerDetail partnerDetail = await _userService.getPartnerDetail(
        partnerId: _authService.currentUser!.uid);
    busy = false;
    return partnerDetail;
  }

  Future<void> updatePartnerInfo(
      {required Partner partner, required PartnerDetail partnerDetail}) async {
    _userService.setPartner(partner: partner);
    _userService.setPartnerDetail(
        partnerId: _authService.currentUser!.uid, partnerDetail: partnerDetail);
  }
}
