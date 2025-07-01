import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TindakanModel {
  final String? id;
  final String penyebab;
  final String namaProduk;
  final double aplikasiProduk;
  final DateTime tanggalAplikasi;
  final String? deskripsi;
  final ProdukModel? produk;

  TindakanModel({
    this.id,
    this.produk,
    required this.penyebab,
    required this.namaProduk,
    required this.aplikasiProduk,
    this.deskripsi,
    required this.tanggalAplikasi,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'produk': produk?.toFirestore(),
      'penyebab': penyebab,
      'namaProduk': namaProduk,
      'aplikasiProduk': aplikasiProduk,
      'deskripsi': deskripsi,
      'tanggalAplikasi': tanggalAplikasi,
    };
  }

  factory TindakanModel.fromFirestore(Map<String, dynamic> map, String tindakanId) {
    return TindakanModel(
      id: tindakanId,
      penyebab: map['penyebab'] as String? ?? '',
      namaProduk: map['namaProduk'] as String? ?? '',
      deskripsi: map['deskripsi'] as String? ?? '',
      aplikasiProduk: (map['aplikasiProduk'] as num?)?.toDouble() ?? 0,
      tanggalAplikasi: map['tanggalAplikasi'] != null
    ? (map['tanggalAplikasi'] as Timestamp).toDate()
    : DateTime.now(),
      produk: map['produk'] != null
        ? ProdukModel.fromFirestore(map['produk'], '')
        : null
    );
  }
}