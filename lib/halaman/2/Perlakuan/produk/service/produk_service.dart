import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'produk';

  Future<void> tambahProduk(ProdukModel map) async {
    try {
      await _db.collection(_collectionPath).add(map.toFirestore());
    } catch (e) {
      throw Exception('Gagal menyimpan data produk');
    }
  }

  Future<void> updateProduk({
    required String docId,
    required ProdukModel data,
  }) async {
    try {
      await _db
        .collection(_collectionPath)
        .doc(docId)
        .update(data.toFirestore());
    } catch (e) {
      throw Exception('Gagal memperbarui data produk: Produk Service');
    }
  }

  Stream<List<ProdukModel>> fetchDataProduk() {
    return _db.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProdukModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  Stream<List<ProdukModel>> fetchDataProdukbyUserId(String userId) {
    if (userId.isEmpty) {
      return Stream.value([]);
    }

    return _db
      .collection(_collectionPath)
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ProdukModel.fromFirestore(doc.data(), doc.id);
        }).toList();
      });
  }

  Future<ProdukModel?> fetchProdukbyId(String produkId) async {
    try {
      final docSnap = await _db.collection(_collectionPath).doc(produkId).get();
      if (docSnap.exists) {
        return ProdukModel.fromFirestore(docSnap.data() as Map<String, dynamic>, docSnap.id);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteProduk(ProdukModel map) async {
    try {
      await _db.collection(_collectionPath).doc(map.id).delete();
    } catch (e) {
      throw Exception('Terjadi kesalahan pada service. (Delete)');
    }
  }
}