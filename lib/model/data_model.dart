

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Lahan {
  final String id;
  final String penggunaId;
  final String namaLahan;
  final String detailLokasi;
  final String varietas;
  final List<LatLng> coordinates;
  final double luasLahan;
  final Timestamp tanggalBuat;
  List<PlantingPeriod>? periodeTanam;
  String? deskripsi;

  Lahan({
    required this.id,
    required this.penggunaId,
    required this.namaLahan,
    required this.varietas,
    required this.detailLokasi,
    required this.coordinates,
    required this.luasLahan,
    required this.tanggalBuat,
    this.periodeTanam,
    this.deskripsi,
  });

  Lahan copyWith({
    String? id,
    String? penggunaId,
    String? namaLahan,
    String? detailLokasi,
    String? varietas,
    List<LatLng>? coordinates,
    double? luasLahan,
    Timestamp? tanggalBuat,
    List<PlantingPeriod>? periodeTanam,
    String? deskripsi,
  }) {
    return Lahan(
      id: id ?? this.id,
      penggunaId: penggunaId ?? this.penggunaId,
      namaLahan: namaLahan ?? this.namaLahan,
      varietas: varietas ?? this.varietas,
      detailLokasi: detailLokasi ?? this.detailLokasi,
      coordinates: coordinates ?? this.coordinates,
      luasLahan: luasLahan ?? this.luasLahan,
      tanggalBuat: tanggalBuat ?? this.tanggalBuat,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }

  factory Lahan.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data= snapshot.data();
    if (data == null) throw Exception('Data Lahan Kosong!');

    List<LatLng> parsedCoordinates = [];
    if (data['coordinates'] != null && data['coordinates'] is List) {
      parsedCoordinates = (data['coordinates'] as List).map((kordinat) {
        if (kordinat is Map && kordinat.containsKey('lat') && kordinat.containsKey('lng')) {
          return LatLng(kordinat['lat'] as double, kordinat['lng'] as double);
        }
        return const LatLng(0, 0);
      }).toList();
    }

  return Lahan(
    id: snapshot.id,
    penggunaId: data['ownerUserId'] as String,
    namaLahan: data['landName'] as String,
    varietas: data['varietas'] as String,
    detailLokasi: data['locationDetail'] as String,
    coordinates: parsedCoordinates,
    luasLahan: (data['area'] as num).toDouble(),
    tanggalBuat: data['createdAt'] as Timestamp,
    deskripsi: data['deskripsi'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'ownerUserId': penggunaId,
      'landName': namaLahan,
      'varietas': varietas,
      'locationDetail': detailLokasi,
      'coordinates': coordinates.map((ll) => {'lat': ll.latitude, 'lng': ll.longitude}).toList(),
      'area': luasLahan,
      'createdAt': tanggalBuat,
      'deskripsi': deskripsi,
    };
  }
}

class PlantingPeriod {
  final String id;
  final String periodName;
  final Timestamp startDate;
  final Timestamp endDate;
  final String status;
  final double targetPanen;

  PlantingPeriod({
    required this.id,
    required this.periodName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.targetPanen,
  });

  PlantingPeriod copyWith({
    String? id,
    String? periodName,
    Timestamp? startDate,
    Timestamp? endDate,
    String? status,
    double? targetPanen,
  }) {
    return PlantingPeriod(
      id: id ?? this.id,
      periodName: periodName ?? this.periodName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      targetPanen: targetPanen ?? this.targetPanen
    );
  }

  factory PlantingPeriod.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception("Data periode tanam kosong!");
    // Data Mentah
    if (data.isEmpty) throw Exception("Data periode tanam kosong!");

    return PlantingPeriod(
      id: snapshot.id,
      periodName: data['periodName'] as String,
      startDate: data['startDate'] as Timestamp,
      endDate: data['endDate'] as Timestamp,
      status: data['status'] as String,
      targetPanen: data['targetPanen']as double,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'cropName': periodName,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'targetPanen': targetPanen,
    };
  }
}