
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as p;

class StorageUser {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageUser();
  Future<String?> uploadGambar ({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage.ref('users/fotoprofil').child('$uid${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      } else {
        return null;
      }
    });
  }
}

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> getDownloadUrlFromOptFolder(String fileName) async {
    try {
      final ref = _storage.ref('opt/$fileName');
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}

class StorageOPT {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageOPT();
  Future<String?> uploadGambarOPT({
    required File file,
    required String uid,
  }) async {
    Reference fileRef = _firebaseStorage.ref('users/gambaropt').child('$uid${p.extension(file.path)}');
    UploadTask task = fileRef.putFile(file);
    return task.then((p) {
      if (p.state == TaskState.success) {
        return fileRef.getDownloadURL();
      } else if (p.state == TaskState.running) {
        throw Exception('$p');
      } else if (p.state == TaskState.error) {
        throw Exception('${p.state}');
      } return null;
    });
  }

  Future<void> deleteGambarOPT(String imageUrl) async {
  try {
    final ref = _firebaseStorage.refFromURL(imageUrl);
    await ref.delete();
  } catch (e) {
    throw Exception('Gagal menghapus gambar dari Firebase Storage: $e');
  }
}
}