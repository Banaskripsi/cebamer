import 'package:cebamer/model/data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LahanService {
  final FirebaseFirestore _fr = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<List<Lahan>> getLahanPengguna() async {
    final user = currentUser;
    if (user == null) {
      return [];
    }

    try {
      final querySnapshot = await _fr
        .collection('lands')
        .where('ownerUserId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .get();

      return querySnapshot.docs
        .map((doc) => Lahan.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      throw Exception('Gagal Memuat Lahan');
    }
  }

  Future<Lahan?> getLahanId(String lahanId) async {
    try {
      final docSnapshot = await _fr
        .collection('lands')
        .doc(lahanId)
        .get();
      if(docSnapshot.exists) {
        return Lahan.fromFirestore(docSnapshot);
      }
      return null;
    } catch (e) {
      throw Exception('Gagal Memuat Data');
    }
  }

  Future<List<PlantingPeriod>> getPlantPeriods(String lahanId) async {
    try {
      final querySnapshot = await _fr
        .collection('lands')
        .doc(lahanId)
        .collection('plantingPeriods')
        .orderBy('startDate', descending: true)
        .get();

      return querySnapshot.docs
        .map((doc) => PlantingPeriod.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      throw Exception('Gagal Memuat Data Periode Tanam');
    }
  }
}