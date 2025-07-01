import 'package:cloud_firestore/cloud_firestore.dart';

class ProdukModel {
  String? id;
  String userId;
  double efektivitasPengendalian; // Dianggap wajib
  double volumeProduk; // Dianggap wajib
  String namaProduk; // Dianggap wajib
  String namaManufakturProduk; // Opsional, default string kosong
  double biayaProduk; // Dianggap wajib
  double registrasiProduk; // Opsional, default 0.0
  String jenisProduk; // Dianggap wajib
  String jenisSubProduk; // Dianggap wajib
  DateTime? tanggalExp; // Opsional

  ProdukModel({
    this.id,
    required this.userId,
    required this.efektivitasPengendalian,
    required this.volumeProduk,
    required this.namaProduk,
    this.namaManufakturProduk = "", // Default value
    required this.biayaProduk,
    this.registrasiProduk = 0.0, // Default value
    required this.jenisProduk,
    required this.jenisSubProduk,
    this.tanggalExp, // Nullable
  });

  Map<String, dynamic> toFirestore() {
    return {
      'namaProduk': namaProduk,
      'userId': userId,
      'efektivitasPengendalian': efektivitasPengendalian,
      'volumeProduk': volumeProduk,
      'namaManufakturProduk': namaManufakturProduk,
      'biayaProduk': biayaProduk,
      'registrasiProduk': registrasiProduk,
      'jenisProduk': jenisProduk,
      'jenisSubProduk': jenisSubProduk,
      'tanggalExp': tanggalExp, // Bisa null, Firestore akan menyimpannya sebagai null
    };
  }

  factory ProdukModel.fromFirestore(Map<String, dynamic> map, String documentId) {
    return ProdukModel(
      id: documentId,
      userId: map['userId'] as String? ?? '',
      efektivitasPengendalian: (map['efektivitasPengendalian'] as num?)?.toDouble() ?? 0.0,
      volumeProduk: (map['volumeProduk'] as num?)?.toDouble() ?? 0.0,
      namaProduk: map['namaProduk'] as String? ?? '',
      namaManufakturProduk: map['namaManufakturProduk'] as String? ?? '',
      biayaProduk: (map['biayaProduk'] as num?)?.toDouble() ?? 0.0,
      registrasiProduk: (map['registrasiProduk'] as num?)?.toDouble() ?? 0.0,
      jenisProduk: map['jenisProduk'] as String? ?? '',
      jenisSubProduk: map['jenisSubProduk'] as String? ?? '',
      // Tangani jika tanggalExp null di Firestore
      tanggalExp: map['tanggalExp'] != null ? (map['tanggalExp'] as Timestamp).toDate() : null,
    );
  }
}