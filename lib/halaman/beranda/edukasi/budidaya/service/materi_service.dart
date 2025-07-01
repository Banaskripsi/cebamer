import 'package:cebamer/halaman/beranda/edukasi/budidaya/model/materi_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MateriService {
  final _db = FirebaseFirestore.instance;

  Stream<List<MateriModel>> getMateri() {
    try {
      return _db.collection('materi').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return MateriModel.fromMap(doc.data(), doc.id);
        }).toList();
      });

    } catch (e) {
      throw Exception('Ada kesalahan materi service: Service: $e');
    }
  }
}