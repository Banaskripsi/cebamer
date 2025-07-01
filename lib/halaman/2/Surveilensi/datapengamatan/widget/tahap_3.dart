import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/produk_daftar.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahapan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/service/pengamatan_service.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class TahapKetiga extends StatefulWidget {
  final int idPengamatan;
  final String judulPengamatan;
  PengamatanLokal pengamatan;
  TahapKetiga({super.key, required this.pengamatan, required this.idPengamatan, required this.judulPengamatan});

  @override
  State<TahapKetiga> createState() => _TahapKetigaState();
}

class _TahapKetigaState extends State<TahapKetiga> {
  final tahap3 = Get.find<PengamatanController>();
  final service = Get.find<PengamatanService>();
  final notifikasi = Get.find<Notifikasi>();
  final tahapan = Get.find<TahapanController>();
  final GlobalKey<FormState> tahap3Key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hasil = await ambildDataFirestore();
      if (hasil != null) {
        setState(() {
          tahap3.firestoreDocId.value = hasil;
        });
      }
    });
  }

  Future<String?> ambildDataFirestore() async {
    try {
      final docRef = await service.fetchDataPengamatanSpesifik(tahap3.lahan!.id, tahap3.periode!.id, widget.idPengamatan);
      if (docRef != null) {
        return docRef.idPengamatanTahap1;
      } else {
        return 'Doc ID Tidak Ditemukan';
      }
    } catch (e) {
      return '';
    }
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: tahap3Key,
          child: Padding(
            padding: paddingLR20,
            child: Column(
              children: [
                j50,
                header(context, judul: 'Tahap 3', deskripsi: 'Input data pada variabel eksternal.'), j20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Input Data Tambahan',
                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                    ), j10,
                    Text(
                      'Terdapat beberapa variabel di luar batas pengamatan, yang diperlukan.'
                    )
                  ],
                ), j20,
                divider(context, 'Input Data'), j20,
                Formnya(
                  icon: Icons.money,
                  controller: tahap3.hargaJual,
                  hintText: 'Harga Jual / Kg',
                  fungsi: () {},
                  inputType: TextInputType.text,
                  suffix: Padding(
                    padding: const EdgeInsets.all(5),
                    child: IconButton(
                      onPressed: () {
                        DialogGlobal().tampilkan(title: 'Harga Jual Bawang Merah', message: 'Anda dapat menginput data harga jual bawang merah setiap 1 kilogram, disesuaikan dengan kondisi pasar wilayah Anda.');
                      },
                      icon: Icon(Icons.info)
                    ),
                  ),
                ), j20,
                Formnya(
                  icon: Remix.product_hunt_fill,
                  controller: tahap3.namaProduk,
                  hintText: 'Produk yang Digunakan',
                  fungsi: () => pilihProduk(context, (produkTerpilih) {
                    tahap3.namaProduk.text = produkTerpilih.namaProduk;
                    tahap3.hargaProduk.text = produkTerpilih.biayaProduk.toString();
                    tahap3.efektivitasproduk.text = produkTerpilih.efektivitasPengendalian.toString();
                    tahap3.beratProduk.text = produkTerpilih.volumeProduk.toString();
                    tahap3.jenisProduk.text = produkTerpilih.jenisProduk;
                  }),
                  inputType: TextInputType.text,
                  readOnly: true,
                ), j10,
                Formnya(
                  controller: tahap3.jenisProduk,
                  hintText: 'Jenis Produk',
                  fungsi: () {},
                  inputType: TextInputType.text,
                  readOnly: true,
                ), j10,              
                Formnya(
                  suffix: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Rp',
                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
                    )
                  ),
                  controller: tahap3.hargaProduk,
                  hintText: 'Harga Produk',
                  fungsi: () {},
                  inputType: TextInputType.text,
                  readOnly: true,
                ),j10,
                Formnya(
                  suffix: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      '%',
                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
                    )
                  ),
                  controller: tahap3.efektivitasproduk,
                  hintText: 'Efektivitas Pengendalian',
                  fungsi: () {},
                  inputType: TextInputType.text,
                  readOnly: true,
                ), j10,
                Formnya(
                  suffix: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Kg',
                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1)
                    )
                  ),
                  controller: tahap3.beratProduk,
                  hintText: 'Volume Produk',
                  fungsi: () {},
                  inputType: TextInputType.text,
                  readOnly: true,
                ), j10,
                j30,
                ElevatedButton.icon(
                  onPressed: () async {
                    if (tahap3.isLoading.value) return;
                    if (!tahap3Key.currentState!.validate()) return;
                    try {
                      bool hasil = await tahap3.uploadDataAdditionalCtrl();
                      final tahap3id = (tahapan.tahapanMap[widget.idPengamatan] ?? [])
                        .firstWhereOrNull((t) => t.urutan == 2);
                      if (tahap3id != null && hasil) {
                        notifikasi.notif(text: 'Berhasil!', subTitle: 'Data telah berhasil diunggah', warna: primer1);
                        await tahapan.updateStatusTahapan(widget.idPengamatan, tahap3id.id!, "Selesai");
                        Get.back();
                      } else {
                        notifikasi.notif(text: 'Gagal', subTitle: 'Silahkan ulangi kembali', warna: salahInd);
                      }
                    } catch (e) {
                      notifikasi.notif(text: 'Gagal', subTitle: 'Silahkan ulangi kembali', warna: salahInd);
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text('Simpan Data')
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}