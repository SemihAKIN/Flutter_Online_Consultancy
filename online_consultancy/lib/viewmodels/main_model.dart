import 'package:online_consultancy/screens/chat/screens/contacts_page.dart';
import 'package:online_consultancy/viewmodels/base_model.dart';

class MainModel extends BaseModel {
  Future? navigateToContacts() async {
    await navigatorService.navigateTo(const ContactsPage());
  }
}
