class PemasukanModel {
  final String pemasukanId;
  final String namaPemasukan;
  final String jenisPemasukan;
  final double nilaiPemasukan;
  final double hasilPanen;
  final double hargaJual;

  PemasukanModel({
    required this.pemasukanId,
    required this.namaPemasukan,
    required this.jenisPemasukan,
    required this.nilaiPemasukan,
    required this.hasilPanen,
    required this.hargaJual,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'namaPemasukan': namaPemasukan,
      'jenisPemasukan': jenisPemasukan,
      'nilaiPemasukan': nilaiPemasukan,
      'hasilPanen': hasilPanen,
      'hargaJual': hargaJual,
    };
  }

  factory PemasukanModel.fromFirestore(Map<String, dynamic> map, String pemasukanId) {
    return PemasukanModel(
      pemasukanId: pemasukanId,
      namaPemasukan: map['namaPemasukan'] as String? ?? '',
      jenisPemasukan: map['jenisPemasukan'] as String? ?? '',
      nilaiPemasukan: map['nilaiPemasukan'] as double? ?? 0,
      hasilPanen: map['hasilPanen'] as double? ?? 0,
      hargaJual: map['hargaJual'] as double? ?? 0,
    );
  }
}