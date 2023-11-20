import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(path).putFile(file);

    uploadTask.snapshotEvents.listen((event) {});

    var snapShot = await uploadTask;

    return await snapShot.ref.getDownloadURL();
  }
}
