import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/add_opsional_pembiayaan.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/edit_opsional_pembiayaan.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DaftarOpsionalPembiayaan extends StatefulWidget {
  const DaftarOpsionalPembiayaan({super.key});

  @override
  State<DaftarOpsionalPembiayaan> createState() => _DaftarOpsionalPembiayaanState();
}

class _DaftarOpsionalPembiayaanState extends State<DaftarOpsionalPembiayaan> {
  final controller = Get.find<PembiayaanController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: Column(
          children: [
            j50,
            header(context, judul: 'Daftar Pembiayaan Berkala', deskripsi: 'Anda dapat melihat catatan pengeluaran tidak tetap disini.'),
            Obx(() {
              if (controller.daftarBiayaOpsional.isEmpty) {
                return Column(
                  children: [
                    Center(child: Text('Anda belum menambahkan data pembiayaan berkala, silahkan tambahkan terlebih dahulu.')),
                    ElevatedButton(
                      onPressed: () => Get.to(() => PembiayaanOpsional()),
                      child: Icon(Icons.add),
                    )
                  ],
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.daftarBiayaOpsional.length,
                itemBuilder: (context, index) {
                  final item = controller.daftarBiayaOpsional[index];
                  return Card(
                    color: primer1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(
                        item.namaBiayaOpsional,
                        style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          j10,
                          Text(
                            item.keteranganBiayaOpsional,
                            style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3)
                          ), j5,
                          Text(
                            DateFormat.yMMMMd('id_ID').format(item.tanggalBiayaOpsional),
                            style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: warnaCerah3)
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 0,
                        children: [
                          IconButton(
                            onPressed: () {
                              DialogGlobal().tampilkan(
                                title: 'Konfirmasi Hapus',
                                message: 'Apakah Anda yakin ingin menghapus data pembiayaan ini?',
                                onConfirm: () {
                                  controller.deletePembiayaanOpsional(item.pembiayaanOpsionalId!);
                                },
                                onCancel: () {},
                                cancelText: 'Batal',
                                confirmText: 'OK'
                              );
                            },
                            icon: Icon(Icons.delete, color: warnaCerah3),
                            style: IconButton.styleFrom(
                              backgroundColor: salahInd
                            )
                          ),
                          IconButton(
                            onPressed: () => Get.to(() => EditOpsionalPembiayaan(), arguments: item),
                            icon: Icon(Icons.edit, color: warnaCerah3),
                            style: IconButton.styleFrom(
                              backgroundColor: primer2
                            )
                          )
                        ],
                      ),
                    )
                  );
                },
              );
            }),
          ],
        )
      )
    );
  }
}