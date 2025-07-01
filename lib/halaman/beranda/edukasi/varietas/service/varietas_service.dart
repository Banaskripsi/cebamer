import 'package:cebamer/halaman/beranda/edukasi/varietas/model/varietas_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VarietasService {
  final _db = FirebaseFirestore.instance;
  Stream<List<VarietasModel>> getVarietas() {
    try {
      return _db.collection('varietas').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return VarietasModel.fromMap(doc.data(), doc.id);
        }).toList();
      });
    } catch (e) {
      throw Exception('Ada kesalahan varietas service: Service $e');
    }
  }
}