import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  var storage = FirebaseStorage.instance;
  Future<bool> addImage(
      {required Uint8List image, required String imageId}) async {
    try {
      await storage.ref("$imageId.jpg").putData(image);
      print("resmi koydum");
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  Future<Uint8List?> getImage({required String imageId}) async {
    try {
      return await storage.ref("$imageId.jpg").getData();
    } catch (e) {
      print("errrrrrrr");
      print(e);
      return null;
    }
  }
  
}
