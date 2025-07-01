
class JenisOPT {
  String? id;
  String userId;
  String namaOPT;
  String dokURL;
  String deskripsi;
  double faktorKoreksi;

  JenisOPT({
    this.id,
    required this.userId,
    required this.namaOPT,
    required this.dokURL,
    required this.deskripsi,
    required this.faktorKoreksi,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'namaOPT': namaOPT,
      'dokURL': dokURL,
      'deskripsi': deskripsi,
      'faktorKoreksi': faktorKoreksi,
    };
  }

  factory JenisOPT.fromFirestore(Map<String, dynamic> data, String documentId) {
    return JenisOPT(
      id: documentId,
      userId: data['userId'] as String? ?? '', 
      namaOPT: data['namaOPT'] as String? ?? '',
      dokURL: data['dokURL'] as String? ?? '', 
      deskripsi: data['deskripsi'] as String? ?? '',
      faktorKoreksi: (data['faktorKoreksi'] as num?)?.toDouble() ?? 0.0,
    );
  }
}