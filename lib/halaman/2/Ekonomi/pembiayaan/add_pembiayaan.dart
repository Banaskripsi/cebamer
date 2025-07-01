import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpDataPembiayaan extends GetView<PembiayaanController> {
  const UpDataPembiayaan({super.key});


  @override
  Widget build(BuildContext context) {
    late final GlobalKey<FormState> pembiayaanKey = GlobalKey<FormState>();
    final notifikasi = Get.find<Notifikasi>();
    final TextInputType textString = TextInputType.text;
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.lahan == null || controller.periode == null) {
          return Center(child: Text("Lahan atau periode tidak valid. Silakan kembali."));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: pembiayaanKey,
            child: Column(
              children: [
                j50,
                header(context, judul: 'Pengeluaran', deskripsi: 'Masukkan biaya pengeluaran Anda untuk periode ini'),
                Column(
                  children: [],
                ),
                j20,
                Formnya(controller: controller.benihCtrl, hintText: 'Benih', inputType: textString), j10,
                Formnya(controller: controller.biayaAirCtrl, hintText: 'Biaya Irigasi', inputType: textString), j10,
                Formnya(controller: controller.olahTanahCtrl, hintText: 'Olah Tanah', inputType: textString), j10,
                Formnya(controller: controller.biayaPengendalianCtrl, hintText: 'Biaya Pengendalian', inputType: textString), j10,
                InkWell(
                    onTap: () => controller.showOpsional.value = !controller.showOpsional.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            controller.showOpsional.value ? Icons.toggle_on : Icons.toggle_off,
                            color: controller.showOpsional.value ? primer3 : Colors.grey,
                            size: 30,
                          ), l10,
                          Text(controller.showOpsional.value ? 'Sembunyikan Data Opsional' : 'Tambahkan Data Opsional')
                        ],
                      ),
                    ),
                  ), j20,
                Visibility(
                  visible: controller.showOpsional.value,
                  maintainState: false,
                  child: Column(
                    children: [
                      Formnya(controller: controller.mulsaCtrl, hintText: 'Mulsa', inputType: textString, isOptional: true), j10,
                      Formnya(controller: controller.pupukCtrl, hintText: 'Pupuk', inputType: textString, isOptional: true), j10,
                      Formnya(controller: controller.pestisidaCtrl, hintText: 'Pestisida', inputType: textString, isOptional: true), j10,
                      Formnya(controller: controller.sewaLahanCtrl, hintText: 'Sewa Lahan', inputType: textString, isOptional: true), j10,
                      Formnya(controller: controller.transportasiCtrl, hintText: 'Transportasi', inputType: textString, isOptional: true), j10,
                      Formnya(controller: controller.upahHarianCtrl, hintText: 'Upah Tenaga Kerja Harian', inputType: textString, isOptional: true), j10,
                      Formnya(controller: controller.biayaLainCtrl, hintText: 'Lainnya', inputType: textString, isOptional: true), j10,
                    ],
                  )
                ),              
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (!pembiayaanKey.currentState!.validate()) return;
                    try {
                      await controller.uploadPembiayaan();
                      notifikasi.notif(text: 'Berhasil!', subTitle: 'Data telah tersimpan di database.', warna: primer1);
                    } catch (e) {
                      notifikasi.notif(text: 'Gagal', subTitle: 'Terjadi kesalahan saat menyimpan data, silahkan coba kembali.', warna: salahInd);
                    }
                  },
                  child: Text('Simpan Data Pembiayaan'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}