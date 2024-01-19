import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseStorageFile {
  static Future<String?> uploadFileToStorage(
      String filename, XFile image) async {
    String imageExtension = image.path.split(".").last.toLowerCase();
    Reference reference =
        FirebaseStorage.instance.ref().child("riders").child(filename);
    UploadTask uploadTask = reference.putFile(
        File(image.path), SettableMetadata(contentType: imageExtension));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }
}
