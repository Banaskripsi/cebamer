import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TahapDuaData extends StatefulWidget {
  final int indexKotak;
  final int pengamatanLokalId;
  final String idPengamatanFirestore;
  const TahapDuaData({super.key, required this.indexKotak, required this.idPengamatanFirestore, required this.pengamatanLokalId});

  @override
  State<TahapDuaData> createState() => _TahapDuaDataState();
}

class _TahapDuaDataState extends State<TahapDuaData> {
  final controller = Get.find<PengamatanController>();
  final notifikasi = Get.find<Notifikasi>();

  final GlobalKey<FormState> inputDataSampelKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.jumlahTanamanC.clear();
    controller.tanamanbergejalaC.clear();
    controller.skor1C.clear();
    controller.skor2C.clear();
    controller.skor3C.clear();
    controller.skor4C.clear();
    controller.skor5C.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PengamatanController>();
    return Scaffold(
      body: Form(
        key: inputDataSampelKey,
        child: Padding(
          padding: paddingLR20,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                j30,
                _header('${widget.indexKotak + 1}'),
                j20,
                //// INPUT DATA
                // JUMLAH TANAMAN
                Row(
                  children: [
                    Flexible(
                      child: Divider(
                        endIndent: 10,
                        indent: 0,
                      ),
                    ),
                    Text('Penghitungan Insidensi tanpa Skor'),
                    Flexible(
                      child: Divider(
                        endIndent: 0,
                        indent: 10,
                      ),
                    )
                  ],
                ), j10,
                _buildForm(
                  controller.jumlahTanamanC,
                  'Jumlah Tanaman'
                  ), j10,
                // TANAMAN BERGEJALA
                _buildForm(
                  controller.tanamanbergejalaC,
                  'Tanaman Bergejala'
                  ), j20,
                Row(
                  children: [
                    Flexible(
                      child: Divider(
                        endIndent: 10,
                        indent: 0,
                      ),
                    ),
                    Text('Penghitungan dengan Indeks Skor'),
                    Flexible(
                      child: Divider(
                        endIndent: 0,
                        indent: 10,
                      ),
                    )
                  ],
                ), j10,
                // SKOR 1
                _buildForm(
                  controller.skor1C,
                  'Tanaman dengan Keparahan Skor 1'
                  ), j10,
                // SKOR 2
                _buildForm(
                  controller.skor2C,
                  'Tanaman dengan Keparahan Skor 2'
                  ), j10,
                // SKOR 3
                _buildForm(
                  controller.skor3C,
                  'Tanaman dengan Keparahan Skor 3'
                  ), j10,
                // SKOR 4
                _buildForm(
                  controller.skor4C,
                  'Tanaman dengan Keparahan Skor 4'
                  ), j10,
                // SKOR 5
                _buildForm(
                  controller.skor5C,
                  'Tanaman dengan Keparahan Skor 5'
                  ), j10,

                // UPLOAD DATA
                Obx(() {
                  return ElevatedButton(
                    onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        if (inputDataSampelKey.currentState?.validate() ?? false) {
                          try {
                            final uploadData = await controller.uploadFungsiDataPengamatan(
                              widget.indexKotak + 1,
                              widget.indexKotak,
                              widget.pengamatanLokalId,
                              true,
                            );
                            if (uploadData) {
                              notifikasi.notif(text: 'Berhasil!', subTitle: 'Data berhasil diunggah dan disimpan.', icon: Icons.check, warna: primer1);
                              Get.back();
                            }
                          } catch (e) {
                            notifikasi.notif(text: 'Gagal!', subTitle: 'Terjadi kesalahan saat mengunggah data, silahkan coba lagi', icon: Icons.close, warna: salahInd);
                          }
                        } else {
                          return;
                        }
                  },
                  child: controller.isLoading.value
                  ? SizedBox(height: 50, width: 50, child: CircularProgressIndicator())
                  : Text('Upload')
                );
                }),
                j20
              ],
            ),
          )
        ),
      )
    );
  }

  Widget _buildForm(TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20)
        )
      ),
      validator: (value) {
     int? jumlahTanaman = int.tryParse(this.controller.jumlahTanamanC.text) ?? 0;
     int? jumlahTanamanBergejala = int.tryParse(this.controller.tanamanbergejalaC.text) ?? 0;
     int? skor1c = int.tryParse(this.controller.skor1C.text);
     int? skor2c = int.tryParse(this.controller.skor2C.text);
     int? skor3c = int.tryParse(this.controller.skor3C.text);
     int? skor4c = int.tryParse(this.controller.skor4C.text);
     int? skor5c = int.tryParse(this.controller.skor5C.text);
     int? jumlahSeluruhTanaman = (skor1c ?? 0) + (skor2c ?? 0) + (skor3c ?? 0) + (skor4c ?? 0) + (skor5c ?? 0);
      if (value == null || value.isEmpty) {
        return 'Masukkan angka valid';
      }
      
      int? inputValue = int.tryParse(value);
      if (inputValue == null) {
        return 'Masukkan angka yang valid';
      }
      
      // Validasi khusus untuk form selain jumlah tanaman
      if (hintText != 'Jumlah Tanaman') {        
        if (inputValue > jumlahTanaman) {
          return 'Tidak boleh melebihi jumlah tanaman ($jumlahTanaman)';
        }
      }
      // Agar tanaman bergejala dan lainnya tidak melebihi jumlah tanaman jika dijumlah
      if (hintText != 'Tanaman Bergejala' && hintText != 'Jumlah Tanaman') {
        if (jumlahTanamanBergejala < jumlahSeluruhTanaman) {
        return 'Melebihi tanaman bergejala ($jumlahTanamanBergejala)';
      }}
      return null;
    },
    );
  }

  Widget _header(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pengambilan Sampel',
          style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)
        ),
        j10,
        Text('Untuk menghitung tingkat keparahan serangan organisme pengganggu tumbuhan, kami membutuhkan data sampel seperti di bawah ini.'), j20,
        Row(
          children: [
            CircleAvatar(
              backgroundColor: primer1,
              child: Text(text),
            ), l20,
            Text(
              'Indeks Petak yang Dipilih',
              style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
            )
          ],
        )
      ],
    );
  }
}