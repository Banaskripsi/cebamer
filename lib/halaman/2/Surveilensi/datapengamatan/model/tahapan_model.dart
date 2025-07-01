class TahapanModel {
  int? id;
  int idPengamatan;
  String namaTahapan;
  String status;
  int urutan;

  TahapanModel({
    this.id,
    required this.idPengamatan,
    required this.namaTahapan,
    required this.status,
    required this.urutan
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_pengamatan': idPengamatan,
      'nama_tahapan': namaTahapan,
      'status': status,
      'urutan': urutan,
    };
  }

  factory TahapanModel.fromMap(Map<String, dynamic> map) {
    return TahapanModel(
      id: map['id'],
      idPengamatan: map['id_pengamatan'],
      namaTahapan: map['nama_tahapan'],
      status: map['status'],
      urutan: map['urutan']
    );
  }
}