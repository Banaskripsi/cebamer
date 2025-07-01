import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/controller/tindakan_controller.dart';
import 'package:cebamer/halaman/2/Perlakuan/produk/produk_daftar.dart';
import 'package:cebamer/halaman/2/Surveilensi/dataOPT/opt_daftar.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class TindakanAdd extends StatelessWidget {
  const TindakanAdd({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TindakanController>();
    late GlobalKey<FormState> tindakanKey = GlobalKey<FormState>();
    return Scaffold(
      body: Form(
        key: tindakanKey,
        child: Padding(
          padding: paddingLR20,
          child: SingleChildScrollView(
            child: Obx(() {
              if (controller.lahan!.id.isEmpty) {
                return Center(child: Text('Data lahan belum dimuat'));
              }
              return Column(
                children: [
                  j30,
                  header(context, judul: 'Tambahkan Tindakan', deskripsi: 'Anda dapat menambahkan data tindakan disini.'),
                  j30,
                  Formnya(
                    fungsi: () => pilihProduk(context, (produkTerpilih) {
                      controller.produk.value = produkTerpilih;
                      controller.namaProdukCtrl.text = produkTerpilih.namaProduk;
                    }),
                    controller: controller.namaProdukCtrl,
                    hintText: 'Produk yang digunakan',
                    labelText: 'Produk',
                    inputType: TextInputType.text,
                    readOnly: true,
                  ), j10,
                  Formnya(
                    fungsi: () async {
                      final opt = await daftarOPT(context);
                      if (opt != null) {
                        controller.penyebabCtrl.text = opt.namaOPT;
                      }
                    },
                    controller: controller.penyebabCtrl,
                    hintText: 'Penyebab tindakan',
                    labelText: 'Jenis OPT',
                    inputType: TextInputType.text,
                    readOnly: true,
                  ), j10,
                  Formnya(
                    controller: controller.aplikasiProdukCtrl,
                    hintText: 'Pengaplikasian Produk',
                    labelText: 'Jumlah Pengaplikasian',
                    inputType: TextInputType.number,
                    prefixText: 'Kg ',
                  ), j10,
                  Formnya(
                    fungsi: () async {
                      final tanggal = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040)
                      );
        
                      if (tanggal != null) {
                        controller.tanggalCtrl.text = DateFormat.yMMMMd('id_ID').format(tanggal);
                        controller.tanggalAplikasiCtrl.value = tanggal;
                      }
                    },
                    controller: controller.tanggalCtrl,
                    hintText: 'Tanggal Pengaplikasian',
                    inputType: TextInputType.text,
                    readOnly: true,
                  ), j10,
                  Formnya(
                    controller: controller.deskripsiCtrl,
                    hintText: 'Keterangan',
                    labelText: 'Keterangan',
                    inputType: TextInputType.text,
                    maxLength: 200,
                    maxLines: 4,
                  )
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primer2,
        onPressed: () async {
          if (!tindakanKey.currentState!.validate()) return;
          final hasil = await controller.uploadDataTindakan();
          if (hasil) {
            Get.back();
            controller.clear();
          }
        },
        child: Icon(Remix.save_2_fill, color: warnaCerah3,),
      ),
    );
  }
}