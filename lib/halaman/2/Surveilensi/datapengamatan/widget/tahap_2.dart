import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/pengamatan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahap2_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/controller/tahapan_controller.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/helper/pengamatanlokal_helper.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/model/pengamatan_helper_model.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/service/pengamatan_service.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/widget/peta_grid.dart';
import 'package:cebamer/halaman/2/Surveilensi/datapengamatan/widget/tahap_2_inputdata.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TahapDua extends StatefulWidget {
  final int idPengamatan;
  final String judulPengamatan;
  PengamatanLokal pengamatanLokal;
  TahapDua({super.key, required this.idPengamatan, required this.judulPengamatan, required this.pengamatanLokal});

  @override
  State<TahapDua> createState() => _TahapDuaState();
}

class _TahapDuaState extends State<TahapDua> {
  final tahapController = Get.find<TahapanController>();
  final pengamatanController = Get.find<PengamatanController>();
  final tahap2Controller = Get.find<Tahap2Controller>();
  final notifikasi = Get.find<Notifikasi>();
  final pengamatan = PengamatanHelper.instance;
  final PengamatanService service = PengamatanService();
  final String controllerTag = 'petagrid';
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadDataPengamatan();
      if (pengamatanController.lahan!.id.isNotEmpty || pengamatanController.periode!.id.isNotEmpty) {
        final hasil = await _ambilDataFirestore();
        if (hasil != null) {
          setState(() {
            pengamatanController.firestoreDocId.value = hasil;
          });
        }
      }
    });
  }

  Future<String?> _ambilDataFirestore() async {
    try {
      final docRef = await service.fetchDataPengamatanSpesifik(pengamatanController.lahan!.id, pengamatanController.periode!.id, widget.idPengamatan);
      if (docRef != null) {
        return docRef.idPengamatanTahap1;
      } else {
        return 'Doc Id Tidak Ditemukan.';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> _loadDataPengamatan() async {
    try {
      final tahapan = tahapController.getTahapanByUrutan(widget.idPengamatan, 0);
      if (tahapan == null) {
        await tahapController.loadTahapan(widget.idPengamatan);
      }
      
      final localData = await pengamatan.getPengamatanbyId(widget.idPengamatan);
      
      if (localData != null) {
        
        pengamatanController.namaOPT.value = localData.namaOPT ?? '';
        pengamatanController.jumlahKotak.value = localData.jumlahKotak;
        pengamatanController.namaMetodePengamatan.value = localData.metodePengamatan;
        
        final updatedPengamatan = widget.pengamatanLokal.copyWith(
          jumlahKotak: localData.jumlahKotak,
          metodePengamatan: localData.metodePengamatan,
        );
        
        setState(() {
          widget.pengamatanLokal = updatedPengamatan;
        });
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan pada loadDataPengamatan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: ListView(
          children: [
            j20,
            header(context, judul: 'Tahap 2', deskripsi: 'Pengambilan Data Sampel'),
            j20,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                j10,
                divider(context, 'Pengambilan Sampel'), j20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PETAKAN LAHAN', style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)), j5,
                    Text('Kami memetakan lahan Anda menjadi beberapa kotak untuk memudahkan dalam pengambilan data sampel. Anda dapat memilih metode apa yang akan digunakan dalam pengambilan sampel. Silahkan untuk mengamati petakan lahan yang tertera dalam kotak.'),
                  ],
                ), j20,
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        tahap2Controller.triggerPetakUpdate();
                        pengamatanController.getDataPengamatanTahap2();
                      },
                      icon: Icon(Icons.refresh)
                    ), l10,
                    Text(
                      'Muat Ulang Data...',
                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer2)
                    ),
                  ],
                ),
                j10,
              ],
            ),
            Obx(() {
              final ctrl = pengamatanController;
              final id = ctrl.firestoreDocId.value;
              if (ctrl.jumlahKotak == null) {
                return Center(child: CircularProgressIndicator());
              }
              return PetaGrid(
                pengamatan: widget.pengamatanLokal,
                onTap: (index) {
                  Get.to(() => TahapDuaData(indexKotak: index, idPengamatanFirestore: id!, pengamatanLokalId: widget.idPengamatan,));
                },
                );
              }
            ), j50,
            divider(context, 'Analisis Sementara'), j10,
            Obx(() {
              if (pengamatanController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primer1, width: 5),
                        color: aksenHijauTua
                      ),
                      child: Center(
                        child: Text(
                          '${pengamatanController.jumlahSeluruhTanaman.value}',
                          style: BanaTemaTeks.temaCerah.headlineLarge!.copyWith(color: Colors.white)
                          )
                        ),
                    ), l20,
                    Expanded(
                      child: Text(
                        'Jumlah Tanaman Teramati...',
                        style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                      ),
                    )
                  ],
                ), j5,
                Row(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primer1, width: 5),
                        color: aksenHijauTua
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: '${pengamatanController.hasilIndidensi.value?.toStringAsFixed(1) ?? 0}',
                            style: BanaTemaTeks.temaCerah.headlineLarge!.copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                text: ' %',
                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white)
                              )
                            ]
                          )
                        )
                        ),
                    ), l20,
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'Insidensi ',
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                          children: [
                            TextSpan(
                              text: 'Serangan OPT Sementara...',
                              style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3)
                            )
                          ]
                        )
                      )
                    )
                  ],
                ), j5,
                Row(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primer1, width: 5),
                        color: aksenHijauTua
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: pengamatanController.hasilSkorKeparahan.value?.toStringAsFixed(1) ?? '0',
                            style: BanaTemaTeks.temaCerah.headlineLarge!.copyWith(color: Colors.white),
                            children: [
                              TextSpan(
                                text: ' %',
                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: Colors.white)
                              )
                            ]
                          )
                        )
                        ),
                    ), l20,
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'Skor Keparahan ',
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                          children: [
                            TextSpan(
                              text: 'Serangan OPT Sementara...',
                              style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3)
                            )
                          ]
                        )
                      )
                    )
                  ],
                ), j5,
              ],
            );
            }),
            j20,
            divider(context, 'Lanjutkan Tahap'), j10,
            ElevatedButton.icon(
              onPressed: () async {
                bool lanjut = await tahap2Controller.validasiKelengkapanDataPetak(widget.pengamatanLokal);
                await pengamatan.updateInsidensiSeverity(widget.idPengamatan, pengamatanController.hasilIndidensi.value!, pengamatanController.hasilSkorKeparahan.value!);
                final tahap2 = (tahapController.tahapanMap[widget.idPengamatan] ?? [])
                  .firstWhere((t) => t.urutan == 1);
                if (lanjut) {
                  tahapController.updateStatusTahapan(widget.idPengamatan, tahap2.id!, "Selesai");
                  notifikasi.notif(text: 'Berhasil!', subTitle: 'Tahap 2 telah selesai, silahkan lanjut ke tahap berikutnya.', warna: primer1);
                  Get.back();
                }
              },
              icon: Icon(Icons.chevron_right_outlined),
              label: Text('Lanjutkan ke Tahap 3')
            )
          ],
        ),
      )
    );
  }
}
