class VarietasModel {
  final String varietasId;
  final String? namaVarietas;
  final String? keterangan;
  final String? penjelasan;
  final Map<String, dynamic>? deskripsi;


  VarietasModel({
    required this.varietasId,
    this.namaVarietas,
    this.keterangan,
    this.penjelasan,
    this.deskripsi
  });

  factory VarietasModel.fromMap(Map<String, dynamic> map, String varietasId) {
    return VarietasModel(
      varietasId: varietasId,
      namaVarietas: map['namaVarietas'] as String? ?? '',
      keterangan: map['keterangan'] as String? ?? '',
      penjelasan: map['penjelasan'] as String? ?? '',
      deskripsi: Map<String, String>.from(map['deskripsi'] ?? {}),
    );
  }
}