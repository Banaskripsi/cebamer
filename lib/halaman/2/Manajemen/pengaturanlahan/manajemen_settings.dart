import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Manajemen/controller/manajemen_controller.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class ManajemenSettings extends StatefulWidget {
  const ManajemenSettings({super.key});

  @override
  State<ManajemenSettings> createState() => _ManajemenSettingsState();
}

class _ManajemenSettingsState extends State<ManajemenSettings> {
  final controller = Get.find<ManajemenController>();
  final GlobalKey<FormState> editManajemenKey = GlobalKey<FormState>();
  final notifikasi = Get.find<Notifikasi>();
  bool? editable;

  @override
  void initState() {
    super.initState();
    controller.namaLahanCtrl.text = controller.lahan!.namaLahan;
    controller.lokasiLahanCtrl.text = controller.lahan!.detailLokasi;
    controller.varietasCtrl.text = controller.lahan!.varietas;
    controller.namaPeriodeCtrl.text = controller.periode!.periodName;
    controller.targetPanenCtrl.text = controller.periode!.targetPanen.toString();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Obx(() {
            return Form(
              key: editManajemenKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    j50,
                    header(context, judul: 'Pengaturan Lahan', deskripsi: 'Anda dapat menambahkan deskripsi lahan atau mengedit informasi lahan.'),
                    j20,
                    InkWell(
                      onTap: () {
                        controller.editable.value = !controller.editable.value;
                      },
                      child: controller.editable.value
                      ? Row(
                        children: [
                          Icon(
                            Icons.toggle_off,
                            color: primer3,
                            size: 44,
                            ),
                          l10,
                          Text(
                            'Edit Data (Non-aktif)',
                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                          )
                        ],
                      )
                      : Row(
                        children: [
                          Icon(
                            Icons.toggle_on,
                            color: primer2,
                            size: 44,
                            ),
                          l10,
                          Text(
                            'Edit Data (Aktif)',
                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                          )
                        ],
                      )
                    ),
                    j5,
                    divider(context, 'Data Siap'),
                    j10,
                    Formnya(
                      icon: Icons.terrain,
                      controller: controller.namaLahanCtrl,
                      hintText: controller.namaLahanCtrl.text,
                      inputType: TextInputType.text,
                      readOnly: controller.editable.value,
                    ),
                    j10,
                    Formnya(
                      icon: Icons.spa,
                      controller: controller.varietasCtrl,
                      hintText: controller.namaLahanCtrl.text,
                      inputType: TextInputType.text,
                      readOnly: controller.editable.value,
                    ),
                    j10,
                    Formnya(
                      icon: Icons.map,
                      controller: controller.lokasiLahanCtrl,
                      hintText: controller.namaLahanCtrl.text,
                      inputType: TextInputType.text,
                      readOnly: controller.editable.value,
                    ),
                    j10,
                    Formnya(
                      icon: Remix.time_zone_fill,
                      controller: controller.namaPeriodeCtrl,
                      hintText: controller.namaLahanCtrl.text,
                      inputType: TextInputType.text,
                      readOnly: controller.editable.value,
                    ),
                    j10,
                    Formnya(
                      icon: Remix.bar_chart_2_fill,
                      controller: controller.targetPanenCtrl,
                      hintText: controller.namaLahanCtrl.text,
                      inputType: TextInputType.number,
                      readOnly: controller.editable.value,
                    ),
                    j20,
                    divider(context, 'Tambahan Data'),
                    j10,
                    Formnya(
                      maxLines: 4,
                      maxLength: 200,
                      controller: controller.deskripsiCtrl,
                      hintText: 'Tambahkan Deskripsi untuk Lahan',
                      inputType: TextInputType.text
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (editManajemenKey.currentState!.validate()) {
                          bool hasil = await controller.editDataLahan();
                          bool result = await controller.editDataPeriode();

                          if (hasil && result) {
                            notifikasi.notif(text: 'Berhasil!', subTitle: 'Data telah berhasil diperbaharui.');
                            Get.back();
                          }
                        } else {
                          return;
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text('Simpan')
                    )
                  ],
                ),
            );
            }
          ),
        ),
      )
    );
  }
}