// DAFTAR PENGAMATAN

class PengamatanLokal {
    final int? id;
    final String? lahanId;
    final String? namaOPT;
    final String? dokURL;
    final String? metodePengamatan;
    final String? targetPanen;
    final int? jumlahKotak;
    final String? docId;
    final String? judul;
    final DateTime? tanggal;
    final double? insidensi;
    final double? severity;

    String? semuaTahapanStatus;

    PengamatanLokal({this.id, this.lahanId, this.judul, this.dokURL, this.tanggal, this.targetPanen, this.docId, this.semuaTahapanStatus, this.namaOPT, this.metodePengamatan, this.jumlahKotak, this.insidensi, this.severity});

    PengamatanLokal copyWith({
    int? id,
    String? lahanId,
    String? namaOPT,
    String? dokURL,
    String? targetPanen,
    String? metodePengamatan,
    int? jumlahKotak,
    String? judul,
    String? docId,
    DateTime? tanggal,
    double? insidensi,
    double? severity,
  }) {
    return PengamatanLokal(
      id: id ?? this.id,
      lahanId: lahanId ?? this.lahanId,
      judul: judul ?? this.judul,
      namaOPT: namaOPT ?? this.namaOPT,
      dokURL: dokURL ?? this.dokURL,
      targetPanen: targetPanen ?? this.targetPanen,
      metodePengamatan: metodePengamatan ?? this.metodePengamatan,
      jumlahKotak: jumlahKotak ?? this.jumlahKotak,
      docId: docId ?? this.docId,
      tanggal: tanggal ?? this.tanggal,
      insidensi: insidensi ?? this.insidensi,
      severity: severity ?? this.severity
    );
  }

    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'lahanId': lahanId,
            'namaOPT': namaOPT,
            'dokURL': dokURL,
            'metodePengamatan': metodePengamatan,
            'targetPanen': targetPanen,
            'jumlahKotak': jumlahKotak,
            'docId': docId,
            'judul': judul,
            'tanggal': tanggal!.toIso8601String(),
            'insidensi': insidensi,
            'severity': severity
        };
    }

    factory PengamatanLokal.fromMap(Map<String, dynamic> map) {
        return PengamatanLokal(
            id: map['id'] as int,
            lahanId: map['lahanId'] as String? ?? '',
            namaOPT: map['namaOPT'] as String? ?? '',
            dokURL: map['dokURL'] as String? ?? '',
            targetPanen: map['targetPanen'] as String? ?? '',
            metodePengamatan: map['metodePengamatan'] as String? ?? '',
            jumlahKotak: map['jumlahKotak'] as int? ?? 1,
            docId: map['docId'] as String,
            judul: map['judul'] as String,
            tanggal: DateTime.parse(map['tanggal']),
            insidensi: map['insidensi'] != null ? (map['insidensi'] as num).toDouble() : null,
            severity: map['severity'] != null ? (map['insidensi'] as num).toDouble() : null,
        );
    }
}