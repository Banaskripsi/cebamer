import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/model/opt_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/opt_daftar.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahapan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/helper/validator.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TahapSatu extends StatefulWidget {
  final int idPengamatan;
  const TahapSatu({super.key, required this.idPengamatan});

  @override
  State<TahapSatu> createState() => _TahapSatuState();
}

class _TahapSatuState extends State<TahapSatu> {
  final tahapanController = Get.find<TahapanController>();
  final controller = Get.find<PengamatanController>();
  final notifikasi = Get.find<Notifikasi>();
  final dbHelper = PengamatanHelper.instance;

  JenisOPT? selectedOPT;

  final GlobalKey<FormState> _tahap1Key = GlobalKey<FormState>();
  List<String> pola = [
    'Tanpa Metode',
    'Simple Random Sampling',
    'Systematic Sampling: Papan Catur',
    'Systematic Sampling: Diagonal',
    'Systematic Sampling: Zig-zag'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tahapanController.loadTahapan(widget.idPengamatan);
    });
  }

  Future<void> _tambahPengamatanLokal(String namaOPT, String metodePengamatan, int jumlahKotak, int idPengamatan, String dokURL) async {
    if (_tahap1Key.currentState!.validate()) {
      try {
        final pengamatanPilih = await dbHelper.getPengamatanbyId(idPengamatan);

        if (pengamatanPilih == null) {
          throw Exception('Data pengamatan tidak ditemukan');
        }

        if (jumlahKotak <= 0) {
          throw Exception('Jumlah kotak harus lebih dari 0');
        }

        final updatePengamatan = pengamatanPilih.copyWith(
          namaOPT: namaOPT,
          metodePengamatan: metodePengamatan,
          jumlahKotak: jumlahKotak,
          dokURL: dokURL,
        );

        await dbHelper.updatePengamatan(updatePengamatan);

        controller.namaOPT.value = namaOPT;
        controller.jumlahKotak.value = jumlahKotak;
        controller.namaMetodePengamatan.value = metodePengamatan;

        if (mounted) {
          notifikasi.notif(text: 'Berhasil!', subTitle: 'Data Berhasil Disimpan di Database Lokal', warna: primer1);
        }
      } catch (e) {
        if (mounted) {
          notifikasi.notif(text: 'Gagal!', subTitle: 'Data gagal disimpan: $e', warna: salahInd);
        }
        throw Exception("Error saving pengamatan data: $e");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.namaOPTController.clear();
    controller.jumlahPengamatan.clear();
    controller.metodePengamatan.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _tahap1Key,
        child: Padding(
          padding: paddingLR20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              j40,
              // H E A D E R
              header(context, judul: 'Tahap 1', deskripsi: 'Silahkan Isi Data Form Berikut'),
              j30,
              _header(),
              j20,
              divider(context, 'Input Data Awal'),
              j20,
              FormBuild(controller: controller.namaOPTController, hintText: 'Pilih OPT', labelText: 'Jenis OPT', onTap: () async {
                  final opt = await daftarOPT(context);
                  if (opt != null) {
                    controller.namaOPTController.text = opt.namaOPT;
                    setState(() {
                      selectedOPT = opt;
                    });
                  }
                }, boolean: true, isian: 'Silahkan pilih jenis opt yang akan diamati.', validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon pilih OPT yang akan diamati.';
                  }
                  return null;
                }), j10,
              FormBuild(controller: controller.jumlahPengamatan, hintText: 'Berapa Petak Lahan yang Akan Diamati?', labelText: 'Jumlah Petak', onTap: () {}, boolean: false, isian: 'Silahkan isikan berapa banyak petak pengambilan sampel.', validator: (value) => BanaValidator.validasiInputKotak(value)), j20,
              divider(context, 'Pilih Metode Pengamatan'),
              j20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    borderRadius: BorderRadius.circular(20),
                    value: controller.metodePengamatan.text.isNotEmpty ? controller.metodePengamatan.text : 'Tanpa Metode',
                    items: pola.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
                        )
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.metodePengamatan.text = newValue!;
                      });
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      DialogGlobal().tampilkan(title: 'Metode Pengamatan', message: 'Jumlah petak yang Anda masukkan akan digunakan sebagai index dan referensi dari banyaknya petakan pengambilan sampel di lahan. Lalu, metode pengamatan digunakan untuk memilih petak lahan yang mana saja yang akan dilakukan pengambilan sampel.');
                    },
                    icon: Icon(Icons.info_outline)
                  ),
                ],
              ), j20,
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!_tahap1Key.currentState!.validate()) return;
                    
                    final tahap1 = (tahapanController.tahapanMap[widget.idPengamatan] ?? [])
                      .firstWhereOrNull((t) => t.urutan == 0);
                      
                    if (tahap1 != null) {
                      try {
                        final jumlahKotak = int.parse(controller.jumlahPengamatan.text);
                        await tahapanController.updateStatusTahapan(widget.idPengamatan, tahap1.id!, "Selesai");
                        controller.uploadFungsiPengamatan(widget.idPengamatan);
                        await _tambahPengamatanLokal(
                          controller.namaOPTController.text,
                          controller.metodePengamatan.text,
                          jumlahKotak,
                          widget.idPengamatan,
                          selectedOPT?.dokURL ?? '',
                        );
                        notifikasi.notif(text: 'Berhasil!', subTitle: 'Data telah diunggah, silahkan lanjut ke tahap selanjutnya.', warna: primer1);
                        Get.back();
                      } catch (e) {
                        notifikasi.notif(text: 'Gagal', subTitle: 'Data gagal diunggah: $e', warna: salahInd);
                      }
                    }
                  },
                  label: Text('Simpan'),
                  icon: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inisialisasi Pengamatan',
          style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)
        ), j10,
        Text(
          'Satu pengamatan hanya dapat digunakan untuk satu jenis Organisme Pengganggu Tumbuhan (OPT).',
          style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3)
        )
      ],
    );
  }
}

class FormBuild extends StatelessWidget {
  const FormBuild({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.onTap,
    required this.boolean,
    required this.isian,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final void Function()? onTap;
  final bool boolean;
  final String isian;
  final String? Function(String? p1)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      readOnly: boolean,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: benarInd),
          borderRadius: BorderRadius.circular(20)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: benarInd),
          borderRadius: BorderRadius.circular(20)
        )
      ),
    );
  }
}
