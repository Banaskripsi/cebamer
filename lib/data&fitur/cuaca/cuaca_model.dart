class Cuaca {

  final String namaKota;
  final double suhu;
  final String kondisi;
  final String kelembaban;
  final String tekanan;
  final String kecepatanAngin;
  final String arahAngin;

  Cuaca({
    required this.namaKota,
    required this.suhu,
    required this.kondisi,
    required this.kelembaban,
    required this.tekanan,
    required this.kecepatanAngin,
    required this.arahAngin,
  });

  factory Cuaca.fromJson(Map<String, dynamic> json) {
    try {
      return Cuaca(
        namaKota: json['name']?.toString() ?? 'Unknown City',
        suhu: (json['main']?['temp'] ?? 0.0).toDouble(),
        kondisi: json['weather']?[0]?['description']?.toString() ?? 'Unknown',
        kelembaban: json['main']?['humidity']?.toString() ?? '0',
        tekanan: json['main']?['pressure']?.toString() ?? '0',
        kecepatanAngin: json['wind']?['speed']?.toString() ?? '0',
        arahAngin: json['wind']?['deg']?.toString() ?? '0'
      );
    } catch (e) {
      rethrow;
    }
  }
}