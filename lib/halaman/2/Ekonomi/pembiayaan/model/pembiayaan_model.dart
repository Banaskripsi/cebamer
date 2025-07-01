class Pembiayaan {
    String? pembiayaanId;
    final String lahanId;
    final String periodeId;
    final String benih;
    final String pupuk;
    final String pestisida;
    final String mulsa;
    final String upahHarian;
    final String transportasi;
    final String sewaLahan;
    final String olahTanah;
    final String biayaAir;
    final String biayaPengendalian;
    final String biayaLain;

    Pembiayaan({
        this.pembiayaanId,
        required this.lahanId,
        required this.periodeId,
        required this.benih,
        required this.biayaAir,
        required this.biayaPengendalian,
        required this.mulsa,
        required this.olahTanah,
        required this.pestisida,
        required this.pupuk,
        required this.sewaLahan,
        required this.transportasi,
        required this.upahHarian,
        required this.biayaLain,
    });

    Map<String, dynamic> toFirestore() {
        return {
            'lahanId': lahanId,
            'periodeId': periodeId,
            'benih': benih,
            'biayaAir': biayaAir,
            'biayaPengendalian': biayaPengendalian,
            'mulsa': mulsa,
            'olahTanah': olahTanah,
            'pestisida': pestisida,
            'pupuk': pupuk,
            'sewaLahan': sewaLahan,
            'transportasi': transportasi,
            'upahHarian': upahHarian,
            'biayaLain': biayaLain,
        };
    }

    factory Pembiayaan.fromFirestore(Map<String, dynamic> map, String lahanId, String periodeId, String pembiayaanId) {
        return Pembiayaan(
            lahanId: lahanId,
            periodeId: periodeId,
            pembiayaanId: pembiayaanId,
            benih: map['benih'] as String? ?? '', 
            biayaAir: map['biayaAir'] as String? ?? '', 
            biayaPengendalian: map['biayaPengendalian'] as String? ?? '', 
            mulsa: map['mulsa'] as String? ?? '', 
            olahTanah: map['olahTanah'] as String? ?? '', 
            pestisida: map['pestisida'] as String? ?? '', 
            pupuk: map['pupuk'] as String? ?? '',
            sewaLahan: map['sewaLahan'] as String? ?? '',
            transportasi: map['transportasi'] as String? ?? '',
            upahHarian: map['upahHarian'] as String? ?? '',
            biayaLain: map['biayaLain'] as String? ?? '',
        );
    }
}


class PembiayaanOpsionalModel {
  final Map<String, dynamic> biayaOpsional;
  final String? pembiayaanOpsionalId;
  final String namaBiayaOpsional;
  final String keteranganBiayaOpsional;
  final double? jumlahBiayaOpsional;
  final DateTime tanggalBiayaOpsional;
  
  PembiayaanOpsionalModel({
    required this.biayaOpsional,
    required this.namaBiayaOpsional,
    required this.keteranganBiayaOpsional,
    required this.tanggalBiayaOpsional,
    this.jumlahBiayaOpsional,
    this.pembiayaanOpsionalId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'biayaOpsional': biayaOpsional,
      'namaBiayaOpsional': namaBiayaOpsional,
      'jumlahBiayaOpsional': jumlahBiayaOpsional,
      'keteranganBiayaOpsional': keteranganBiayaOpsional,
      'tanggalBiayaOpsional': tanggalBiayaOpsional.toIso8601String(),
    };
  }

  factory PembiayaanOpsionalModel.fromFirestore(Map<String, dynamic> map, String pembiayaanOpsionalId) {
    return PembiayaanOpsionalModel(
      biayaOpsional: Map<String, dynamic>.from(map['biayaOpsional'] ?? {}),
      pembiayaanOpsionalId: pembiayaanOpsionalId,
      namaBiayaOpsional: map['namaBiayaOpsional'] as String? ?? '',
      keteranganBiayaOpsional: map['keteranganBiayaOpsional'] as String? ?? '',
      jumlahBiayaOpsional: map['jumlahBiayaOpsional'] as double? ?? 0,
      tanggalBiayaOpsional: DateTime.parse(map['tanggalBiayaOpsional'])
    );
  }
}