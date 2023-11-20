import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../core/locater.dart';
import '../core/services/storage_service.dart';
import 'base_model.dart';

class ConversationModel extends BaseModel {
  final StorageService _storageService = getIt<StorageService>();
  final ImagePicker _picker = ImagePicker();
  String uploadedMedia = "";
  late CollectionReference _ref;

  Stream<QuerySnapshot> getConversation(String id) {
    _ref = FirebaseFirestore.instance.collection('conversations/$id/messages');

    return _ref.orderBy('timeStamp').snapshots();
  }

  String formatMessagesTimeStamp(DateTime time) {
    return '${time.hour}:${time.minute}';
  }

  Future<void> add(Map<String, dynamic> data) async {
    await _ref.add(data);
    uploadedMedia = "";
    notifyListeners();
  }

  uploadMedia(ImageSource source) async {
    try {
      XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) return;

      var file = await _storageService.uploadFile(File(pickedFile.path),
          "gallery/${DateTime.now().millisecondsSinceEpoch.toString()}.${pickedFile.path.split(".").last}");
      notifyListeners();
      uploadedMedia = file;
    } catch (e) {
      print(e);
    }
  }
}
