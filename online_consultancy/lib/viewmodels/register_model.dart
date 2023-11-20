import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:online_consultancy/core/locater.dart';
import 'package:online_consultancy/core/services/storage_service.dart';
import 'package:online_consultancy/viewmodels/base_model.dart';

class RegisterModel extends BaseModel {
  final StorageService _storageService = getIt<StorageService>();
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  Future<File?> getProfileImage(ImageSource source) async {
    pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile!.path);
    }
    return null;
  }

  Future<String?> uploadProfileImage(File? pickedFile) async {
    try {
      if (pickedFile != null) {
        var file = await _storageService.uploadFile(pickedFile,
            "profileImage/${DateTime.now().millisecondsSinceEpoch.toString()}.${pickedFile.path.split(".").last}");
        notifyListeners();
        return file;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
