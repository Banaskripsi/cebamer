import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/model/tindakan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TindakanService {
  final _db = FirebaseFirestore.instance;

  Future<void> uploadDataTindakan(TindakanModel data, String lahanId, String periodeId) async {
    try {
      await _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('tindakan')
        .add(data.toFirestore());
    } catch (e) {
      throw Exception('Gagal mengunggah data tindakan: Service');
    }
  }

  Stream<List<TindakanModel>> getTindakan(String lahanId, String periodeId) {
    return _db.collection('lands').doc(lahanId).collection('plantingPeriods').doc(periodeId).collection('tindakan').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TindakanModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deleteTindakan({
    required String lahanId,
    required String periodeId,
    required String documentId,
  }) async {
    try {
      await _db.collection('lands').doc(lahanId).collection('plantingPeriods').doc(periodeId).collection('tindakan').doc(documentId).delete();
    } catch (e) {
      throw Exception('Terjadi kesalahan: Service');
    }
  }
}