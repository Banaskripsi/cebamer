import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class PembiayaanOpsional extends GetView<PembiayaanController> {
  const PembiayaanOpsional({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> biayaOpsionalKey = GlobalKey<FormState>();
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: Obx(() => SingleChildScrollView(
          child: Form(
            key: biayaOpsionalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  j50,
                  header(context, judul: 'Tambah Biaya Opsional', deskripsi: 'Anda dapat menambahkan data biaya opsional.'),
                  j30,
                  divider(context, 'Tambahkan Kelompok Biaya'),
                  j20,
                  Formnya(
                    icon: Remix.function_add_fill,
                    controller: controller.namaBiayaOpsionalCtrl,
                    hintText: 'Nama Kelompok Biaya',
                    inputType: TextInputType.text,
                    
                  ),
                  j10,
                  Formnya(
                    
                    controller: controller.keteranganBiayaOpsionalCtrl,
                    hintText: 'Keterangan Kelompok Biaya',
                    inputType: TextInputType.text,
                    maxLines: 4,
                    maxLength: 200,
                  ), j20,
                  divider(context, 'Data Biaya'), j10,
                  ...List.generate(controller.biayaFieldCount.value, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller.biayaNamaCtrl[index],
                              decoration: InputDecoration(
                                labelText: 'Nama Biaya',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: controller.biayaNilaiCtrl[index],
                              decoration: InputDecoration(
                                labelText: 'Nilai Biaya',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ), l10,
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => controller.hapusFieldBiayaLainnya(index),
                            style: IconButton.styleFrom(
                              backgroundColor: salahInd
                            )
                          )
                        ],
                      ),
                    );
                  }),
                  j20,
                  Row(
                    children: [
                      IconButton(
                        onPressed: controller.tambahFieldBiayaLainnya,
                        icon: Icon(Icons.add_card, size: 30)
                      ), l10,
                      Text(
                        'Tambahkan Form Field',
                        style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3, fontStyle: FontStyle.italic)
                      )
                    ],
                  )
                ],
              ),
          ),
        )
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          if (biayaOpsionalKey.currentState!.validate()) {
            bool hasil = await controller.uploadDataPembiayaanOpsional();
            if (hasil) {
              controller.namaBiayaOpsionalCtrl.clear();
              controller.keteranganBiayaOpsionalCtrl.clear();
              controller.resetFormBiayaOpsional();
              Get.back();
            }
          } else {
            return;
          }
        },
        icon: Icon(Icons.save),
        label: Text('Simpan data biaya')
      ),
    );
  }
}