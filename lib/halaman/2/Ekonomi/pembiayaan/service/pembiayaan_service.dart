import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/model/pembiayaan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PembiayaanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final selectedLahan = Get.find<SelectedLahanController>();
  final selectedPeriode = Get.find<SelectedPeriodeController>();
  final String _cltetap = 'pembiayaanTetap';
  final String _clopsional = 'pembiayaanOpsional';

  Future<void> uploadDataPembiayaan(Pembiayaan data, String lahanId, String periode) async {
    try {
      await _db.collection('lands').doc(lahanId).collection('plantingPeriods').doc(periode).collection(_cltetap).add(data.toFirestore());
    } catch (e) {
      throw Exception('Tidak dapat mengupload data pembiayaan!');
    }
  }

  Future<void> updateDataPembiayaan({
    required String lahanId,
    required String periodeId,
    required String documentId,
    required Pembiayaan data,
  }) async {
    try {
      await _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection(_cltetap)
        .doc(documentId)
        .update(data.toFirestore());
    } catch (e) {
      throw Exception('Gagal untuk memperbarui data pembiayaan!');
    }
  }

  Future<void> uploadDataPembiayaanOpsional(PembiayaanOpsionalModel data, String lahanId, String periode) async {
    try {
      await _db.collection('lands').doc(lahanId).collection('plantingPeriods').doc(periode).collection(_clopsional).add(data.toFirestore());
    } catch (e) {
      throw Exception('Tidak dapat mengupload data pembiayaan opsional!');
    }
  }

  Future<void> updatePembiayaanOpsional({
    required String lahanId,
    required String periode,
    required String documentId,
    required PembiayaanOpsionalModel data,
  }) async {
    try {
      await _db
          .collection('lands')
          .doc(lahanId)
          .collection('plantingPeriods')
          .doc(periode)
          .collection(_clopsional)
          .doc(documentId)
          .update(data.toFirestore());
    } catch (e) {
      throw Exception('Gagal memperbarui data pembiayaan opsional!');
    }
  }

  Future<void> deletePembiayaanOpsional({
    required String lahanId,
    required String periode,
    required String documentId,
  }) async {
    try {
      await _db
          .collection('lands')
          .doc(lahanId)
          .collection('plantingPeriods')
          .doc(periode)
          .collection(_clopsional)
          .doc(documentId)
          .delete();
    } catch (e) {
      throw Exception('Gagal menghapus data pembiayaan opsional!');
    }
  }

  Stream<List<Pembiayaan>> getPembiayaan(String lahanId, String periode) {
    return _db.collection('lands').doc(lahanId).collection('plantingPeriods').doc(periode).collection(_cltetap).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Pembiayaan.fromFirestore(doc.data(), selectedLahan.idLahanTerpilih!, selectedPeriode.idPlantingPeriod!, doc.id);
      }).toList();
    });
  }

  Stream<List<PembiayaanOpsionalModel>> getPembiayaanOpsional(String lahanId, String periode) {
    return _db.collection('lands').doc(lahanId).collection('plantingPeriods').doc(periode).collection(_clopsional).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return PembiayaanOpsionalModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}