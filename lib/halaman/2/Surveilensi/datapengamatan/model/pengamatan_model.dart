import 'package:cebamer/halaman/2/Perlakuan/produk/model/produk_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PengamatanModel {
  final int pengamatanId;
  final String? idPengamatanTahap1;
  final String metodePengamatan;
  final String namaOPT;
  final int jumlahKotak;
  final List<PengamatanDataModel> pengamatanDataModel;

  PengamatanModel({required this.pengamatanId, this.idPengamatanTahap1, required this.metodePengamatan,required this.namaOPT, required this.jumlahKotak, this.pengamatanDataModel = const []});

  Map<String, dynamic> toMap() {
    return {
      'pengamatanId': pengamatanId,
      'metodePengamatan': metodePengamatan,
      'namaOPT': namaOPT,
      'jumlahKotak': jumlahKotak,
    };
  }

  factory PengamatanModel.fromMap(Map<String, dynamic> map, {String? firestoreDocId}) {
    List<PengamatanDataModel> parsedDataPengamatan = [];
    if (map['detailDataKotak'] != null && map['detailDataKota'] is Map) {
      Map<String, dynamic> detailMap = map['detailDataKotak'] as Map<String, dynamic>;
      detailMap.forEach((key, value) {
        if (value is Map<String, dynamic> && firestoreDocId != null) {
          parsedDataPengamatan.add(PengamatanDataModel.fromMap(key, value, firestoreDocId));
        }
      });
    }
    return PengamatanModel(
      pengamatanId: map['pengamatanId'] as int? ?? 0,
      idPengamatanTahap1: firestoreDocId!,
      metodePengamatan: map['metodePengamatan'] as String? ?? '',
      namaOPT: map['namaOPT'] as String? ?? '',
      jumlahKotak: map['jumlahKotak'] as int? ?? 0,
      pengamatanDataModel: parsedDataPengamatan
    );
  }

  factory PengamatanModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    final firestoreDocId = doc.id;
    List<PengamatanDataModel> parsedDataPengamatan = [];
    if (data['detailDataKotak'] != null && data['detailDataKota'] is Map) {
      Map<String, dynamic> detailMap = data['detailDataKotak'] as Map<String, dynamic>;
      detailMap.forEach((key, value) {
        if (value is Map<String, dynamic> && firestoreDocId.isNotEmpty) {
          parsedDataPengamatan.add(PengamatanDataModel.fromMap(key, value, firestoreDocId));
        }
      });
    }
    return PengamatanModel(
      pengamatanId: data['pengamatanId'] as int? ?? 0,
      idPengamatanTahap1: doc.id,
      metodePengamatan: data['metodePengamatan'] as String? ?? '',
      namaOPT: data['namaOPT'] as String? ?? '',
      jumlahKotak: data['jumlahKotak'] as int? ?? 0,
      pengamatanDataModel: parsedDataPengamatan
    );
  }
}

class PengamatanDataModel {
  final int indexKotak;
  final int? jumlahtanaman;
  final int? tanamanbergejala;
  final int? skor1;
  final int? skor2;
  final int? skor3;
  final int? skor4;
  final int? skor5;

  PengamatanDataModel({
    required this.indexKotak,
    this.jumlahtanaman,
    this.tanamanbergejala,
    this.skor1,
    this.skor2,
    this.skor3,
    this.skor4,
    this.skor5
  });

  factory PengamatanDataModel.fromMap(String kotakKey, Map<String, dynamic> map, String pengamatanFirestoreId) {
    return PengamatanDataModel(
      indexKotak: int.tryParse(kotakKey.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
      jumlahtanaman: map['jumlahtanaman'] is int ? map['jumlahtanaman'] : (int.tryParse(map['jumlahtanaman']?.toString() ?? '0') ?? 0),
      tanamanbergejala: map['tanamanbergejala'] is int ? map['tanamanbergejala'] : (int.tryParse(map['tanamanbergejala']?.toString() ?? '0') ?? 0),
      skor1: map['skor1'] is int ? map['skor1'] : (int.tryParse(map['skor1']?.toString() ?? '0') ?? 0),
      skor2: map['skor2'] is int ? map['skor2'] : (int.tryParse(map['skor2']?.toString() ?? '0') ?? 0),
      skor3: map['skor3'] is int ? map['skor3'] : (int.tryParse(map['skor3']?.toString() ?? '0') ?? 0),
      skor4: map['skor4'] is int ? map['skor4'] : (int.tryParse(map['skor4']?.toString() ?? '0') ?? 0),
      skor5: map['skor5'] is int ? map['skor5'] : (int.tryParse(map['skor5']?.toString() ?? '0') ?? 0),
    );
  }

  Map<String, dynamic> toApalahMap() {
    return {
      'jumlahtanaman': jumlahtanaman,
      'tanamanbergejala': tanamanbergejala,
      'skor1': skor1,
      'skor2': skor2,
      'skor3': skor3,
      'skor4': skor4,
      'skor5': skor5
    };
  }

  Map<String, dynamic> toFullMap() {
    return {
      'indexKotak': indexKotak,
      'jumlahtanaman': jumlahtanaman,
      'tanamanbergejala': tanamanbergejala,
      'skor1': skor1,
      'skor2': skor2,
      'skor3': skor3,
      'skor4': skor4,
      'skor5': skor5
    };
  }
}

class PengamatanModelAdditional {
  final double hargaJual;
  final String namaproduk;
  final double efektivitasPengendalian;
  final double hargaProduk;
  final double beratProduk;
  final double severity;
  final double intensitas;

  PengamatanModelAdditional({
    required this.hargaJual,
    required this.namaproduk,
    required this.efektivitasPengendalian,
    required this.hargaProduk,
    required this.beratProduk,
    required this.severity,
    required this.intensitas,
  });

  factory PengamatanModelAdditional.fromProduk({
    required double hargaJual,
    required double severity,
    required double intensitas,
    required ProdukModel produk,
  }) {
    return PengamatanModelAdditional(
      hargaJual: hargaJual,
      severity: severity,
      intensitas: intensitas,
      namaproduk: produk.namaProduk,
      efektivitasPengendalian: produk.efektivitasPengendalian,
      hargaProduk: produk.biayaProduk,
      beratProduk: produk.volumeProduk,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hargaJual': hargaJual,
      'severity': severity,
      'intensitas': intensitas,
      'namaproduk': namaproduk,
      'efektivitasPengendalian': efektivitasPengendalian,
      'hargaProduk': hargaProduk,
      'beratProduk': beratProduk,
    };
  }
}