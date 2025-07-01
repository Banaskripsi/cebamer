import 'package:cebamer/controller/lahan_controller.dart';
import 'package:cebamer/controller/periode_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PengamatanService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final lahan = Get.find<SelectedLahanController>();
  final periode = Get.find<SelectedPeriodeController>();
  

  // UPLOAD DATA TAHAP 1
  Future<DocumentReference> uploadPengamatan(PengamatanModel data, String lahanId, String periodeId) async {
    try {
      final docRef = await _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .add(data.toMap());
      return docRef;
    } catch (e) {
      rethrow;
    }
  }

  // UPLOAD DATA TAHAP 2
  Future<void> uploadDataPengamatan(String lahanId, String periodeId, PengamatanDataModel data, String pengamatanFirestoreDocId) async {
    try {
      final dataPengamatan = _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .doc(pengamatanFirestoreDocId);

      String infoFile = "informasiPetakan${data.indexKotak}";
      Map<String, dynamic> dataPetak = data.toFullMap();
      await dataPengamatan.update({
        infoFile: dataPetak
      });
    } catch (e) {
      rethrow;
    }
  }

  // UPLOAD DATA TAHAP 3
  Future<void> uploadDataAdditional(String lahanId, String periodeId, String pengamatanFirestoreDocId, PengamatanModelAdditional data) async {
    try {
      final dataTahap3 = _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .doc(pengamatanFirestoreDocId);

      String infoTahap3 = 'tahap3';
      Map<String, dynamic> datatahap3 = data.toMap();
      await dataTahap3.update({
        infoTahap3: datatahap3
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<PengamatanModelAdditional?> fetchDataAdditional(String lahanId, String periodeId, String firestoreDocId) async {
    try {
      final docRef = _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .doc(firestoreDocId);

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('tahap3') && data['tahap3'] is Map<String, dynamic>) {
          final tahap3Data = data['tahap3'] as Map<String, dynamic>;
          return PengamatanModelAdditional(
            hargaJual: tahap3Data['hargaJual'] as double,
            severity: tahap3Data['severity'] as double,
            intensitas: tahap3Data['intensitas'] as double,
            namaproduk: tahap3Data['namaproduk'] as String,
            efektivitasPengendalian: tahap3Data['efektivitasPengendalian'] as double,
            hargaProduk: tahap3Data['hargaProduk'] as double,
            beratProduk: tahap3Data['beratProduk'] as double,
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

//   Future<PengamatanModel?> getPengamatanLengkapById(String lahanId, String periodeId, String pengamatanFirestoreDocId) async {
//     try {
//       final docSnap = await _db
//           .collection('lands')
//           .doc(lahanId)
//           .collection('plantingPeriods')
//           .doc(periodeId)
//           .collection('pengamatan')
//           .doc(pengamatanFirestoreDocId)
//           .get();

//       if (docSnap.exists) {
//         return PengamatanModel.fromFirestore(docSnap); // Ini akan mem-parse detailDataKotak
//       }
//       return null;
//     } catch (e) {
//       print("Error fetching pengamatan lengkap by id: $e");
//       rethrow;
//     }
//   }
// }


  // Fetch Data Berdasarkan ID (TAHAP 1)
  Future<List<PengamatanModel>> fetchDataPengamatan(String lahanId, String periodeId, int pengamatanId) async {
    try {
      final snapshot = await _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .where('pengamatanId', isEqualTo: pengamatanId)
        .limit(1)
        .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.map((doc) {
          final data = PengamatanModel.fromMap(doc.data());
          return data;
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String?> getPengamatanDocId(String lahanId, String periodeId, int pengamatanId) async {
  try {
    final snapshot = await _db
      .collection('lands')
      .doc(lahanId)
      .collection('plantingPeriods')
      .doc(periodeId)
      .collection('pengamatan')
      .where('pengamatanId', isEqualTo: pengamatanId)
      .limit(1)
      .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.id;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

  // Fetch Data Berdasarkan ID (TAHAP 2)
  Future<List<PengamatanDataModel>> fetchDataPengamatanTahap2(String lahanId, String periodeId, String docId) async {
    List<PengamatanDataModel> daftarDataPengamatan = [];
    try {
      DocumentReference docRef = _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .doc(docId);

      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;
        dataMap.forEach((fieldKey, fieldValue) {
          if (fieldKey.startsWith("informasiPetakan") && fieldValue is Map<String, dynamic>) {
            try {
              PengamatanDataModel dataModel = PengamatanDataModel.fromMap(
                fieldKey,
                fieldValue,
                docId
              );
              daftarDataPengamatan.add(dataModel);
            } catch (e) {
              rethrow;
            }
          }
        });
        daftarDataPengamatan.sort((a, b) => a.indexKotak.compareTo(b.indexKotak));
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat fetchDataPengamatanTahap2: $e');
    }
    return daftarDataPengamatan;
  }

  Future<PengamatanModel?> fetchDataPengamatanSpesifik(String lahanId, String periodeId, int pengamatanId) async {
    try {
      CollectionReference clRef = _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan');

      QuerySnapshot snapshot = await clRef
        .where('pengamatanId', isEqualTo: pengamatanId)
        .limit(1)
        .get();
      
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        return PengamatanModel.fromFirestore(doc);
      } 
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteDataPengamatanSpesifik(String lahanId, String periodeId, int pengamatanId) async {
    try {
      final doc = await _db
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .doc(periodeId)
        .collection('pengamatan')
        .where('pengamatanId', isEqualTo: pengamatanId)
        .get();

        for (var snapshot in doc.docs) {
          await snapshot.reference.delete();
        }

    } catch (e) {
      rethrow;
    }
  }
}