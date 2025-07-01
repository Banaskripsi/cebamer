import 'package:cebamer/halaman/2/Surveilensi/dataOPT/model/opt_model.dart';
import 'package:cebamer/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class JenisOPTService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final storage = Get.find<StorageOPT>();
  final String _collectionPath = 'jenisopt';

  Future<void> tambahFoto(JenisOPT data) async {
    try {
      await _db.collection(_collectionPath).add(data.toJson());
    } catch (e) {
      throw Exception('Gagal menyimpan data JenisOPT ke Firestore: $e');
    }
  }
  Stream<List<JenisOPT>> getAllJenisOPTStream() {
    return _db.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return JenisOPT.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<JenisOPT>> getJenisOPTByUserIdStream(String userId) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }
    return _db
        .collection(_collectionPath)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return JenisOPT.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<JenisOPT?> getJenisOPTById(String optId) async {
    try {
      final docSnapshot = await _db.collection(_collectionPath).doc(optId).get();
      if (docSnapshot.exists) {
        return JenisOPT.fromFirestore(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteJenisOPT(JenisOPT data) async {
  try {
    await _db.collection(_collectionPath).doc(data.id).delete();

    if (data.dokURL.isNotEmpty) {
      await storage.deleteGambarOPT(data.dokURL);
    }
  } catch (e) {
    throw Exception("Gagal menghapus data JenisOPT dan gambar dari Firebase: $e");
  }
}
}