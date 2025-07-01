import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/model/pembiayaan_model.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class DaftarPembiayaan extends StatefulWidget {
  const DaftarPembiayaan({super.key});

  @override
  State<DaftarPembiayaan> createState() => _DaftarPembiayaanState();
}

class _DaftarPembiayaanState extends State<DaftarPembiayaan> {
  late PembiayaanController controller;
  Pembiayaan? selectedItem;

  @override
  void initState() {
    super.initState();
    try {
      controller = Get.find<PembiayaanController>();
      if (controller.lahan == null || controller.periode == null) {
        Get.snackbar(
          'Peringatan', 
          'Lahan atau Periode belum dipilih. Silakan pilih lahan dan periode terlebih dahulu.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        Get.back();
        return;
      }
      controller.listenPembiayaan();
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Gagal memuat data pembiayaan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.back();
    }
  }

  void _setItem(Pembiayaan data) {
    selectedItem = data;
    controller.benihCtrl.text = data.benih;
    controller.biayaAirCtrl.text = data.biayaAir;
    controller.biayaPengendalianCtrl.text = data.biayaPengendalian;
    controller.olahTanahCtrl.text = data.olahTanah;
    controller.mulsaCtrl.text = data.mulsa;
    controller.pupukCtrl.text = data.pupuk;
    controller.pestisidaCtrl.text = data.pestisida;
    controller.sewaLahanCtrl.text = data.sewaLahan;
    controller.transportasiCtrl.text = data.transportasi;
    controller.upahHarianCtrl.text = data.upahHarian;
    controller.biayaLainCtrl.text = data.biayaLain;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Memuat data...'),
                ],
              ),
            );
          }

          if (controller.daftarBiaya.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data pengeluaran tetap',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan pengeluaran tetap untuk melihat data',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('Kembali'),
                  ),
                ],
              ),
            );
          }
          Pembiayaan data = controller.daftarBiaya.first;
          if (selectedItem == null) {
            _setItem(data);
          }
          return SingleChildScrollView(
            child: Obx(()
              => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  j50,
                  header(context, judul: 'Detail Pengeluaran Tetap', deskripsi: 'Anda dapat melihat dan memperbarui data pembiayaan tetap disini.'),
                  j20,
                  Text(
                    'Pengeluaran tetap untuk...',
                    style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3, fontStyle: FontStyle.italic),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Lahan:  ',
                      style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3),
                      children: [
                        TextSpan(
                          text: controller.lahan?.namaLahan ?? "Tidak diketahui",
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1),
                        )
                      ]
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Pada periode: ',
                      style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3),
                      children: [
                        TextSpan(
                          text: controller.periode?.periodName ?? "Tidak diketahui",
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1),
                        )
                      ]
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.editableBiaya.value = !controller.editableBiaya.value;
                        },
                        child: controller.editableBiaya.value
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
                              style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3, fontStyle: FontStyle.italic),
                            )
                          ],
                        )
                        : Row(
                          children: [
                            Icon(
                              Icons.toggle_on,
                              color: primer1,
                              size: 44,
                              ),
                            l10,
                            Text(
                              'Edit Data (Aktif)',
                              style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: !controller.editableBiaya.value,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (selectedItem?.pembiayaanId != null) {
                              final hasil = await controller.updateDataPembiayaan(selectedItem!.pembiayaanId!);
                              if (hasil) {
                                Get.back();
                              }
                            } else {
                              debugPrint('DocumentId tidak ditemukan');
                            }
                          },
                          icon: Icon(Remix.save_2_fill),
                          label: Text('Perbarui')
                        )
                      ),
                    ],
                  ), j30,
                  divider(context, 'Daftar Biaya'), j20,
                  j30,
                  
                  Column(
                    children: [
                      Formnya(
                        controller: controller.benihCtrl,
                        hintText: 'Benih',
                        labelText: 'Benih',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.biayaAirCtrl,
                        hintText: 'Biaya Air',
                        labelText: 'Air/Irigasi',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.biayaPengendalianCtrl,
                        hintText: 'Biaya Pengendalian',
                        labelText: 'Pengendalian',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.olahTanahCtrl,
                        hintText: 'Olah Tanah',
                        labelText: 'Olah Tanah',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.pupukCtrl,
                        hintText: 'Pupuk',
                        labelText: 'Pupuk',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.pestisidaCtrl,
                        hintText: 'Pestisida',
                        labelText: 'Pestisida',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.mulsaCtrl,
                        hintText: 'Mulsa',
                        labelText: 'Mulsa',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.sewaLahanCtrl,
                        hintText: 'Sewa Lahan',
                        labelText: 'Sewa Lahan',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.sewaLahanCtrl,
                        hintText: 'Transportasi',
                        labelText: 'Transportasi',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.upahHarianCtrl,
                        hintText: 'Upah Harian',
                        labelText: 'Upah Harian',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ),
                      j10,
                      Formnya(
                        controller: controller.biayaLainCtrl,
                        hintText: 'Biaya Lain',
                        labelText: 'Biaya Lainnya',
                        inputType: TextInputType.text,
                        readOnly: controller.editableBiaya.value,
                      ), j20,
                      j40,
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}