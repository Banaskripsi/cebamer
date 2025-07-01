class ChartPembiayaanModel {
  final String kategori;
  final double jumlah;

  ChartPembiayaanModel({
    required this.kategori,
    required this.jumlah,
  });

  factory ChartPembiayaanModel.fromMap(Map<String, dynamic> data) {
    return ChartPembiayaanModel(
      kategori: data['kategori'],
      jumlah: (data['jumlah'] as num).toDouble()
    );
  }
}