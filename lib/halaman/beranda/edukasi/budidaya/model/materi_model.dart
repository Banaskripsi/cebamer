

import 'package:cloud_firestore/cloud_firestore.dart';

class MateriModel {
  final String? id;
  final String? headerJudul;
  final String? headerDeskripsi;
  final List<MateriItem>? materiItem;
  final Timestamp? createdAt;

  MateriModel({
    this.id,
    this.headerJudul,
    this.headerDeskripsi,
    this.materiItem,
    this.createdAt,
  });

  factory MateriModel.fromMap(Map<String, dynamic> map, String materiId) {
    return MateriModel(
      id: materiId,
      headerJudul: map['headerJudul'] as String? ?? '',
      headerDeskripsi: map['headerDeskripsi'] as String? ?? '',
      materiItem: (map['materiItem'] as List<dynamic>? ?? []).map((item) {
        return MateriItem.fromMap(item);
      }).toList(),
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] as Timestamp : null,
    );
  }
}

class MateriItem {
  final String judulMateri;
  final String deskripsiMateri;

  MateriItem({
    required this.judulMateri,
    required this.deskripsiMateri,
  });

  factory MateriItem.fromMap(Map<String, dynamic> map) {
    return MateriItem(
      judulMateri: map['judulMateri'] ?? '',
      deskripsiMateri: map['deskripsiMateri'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'judulMateri': judulMateri,
      'deskripsiMateri': deskripsiMateri,
    };
  }
}