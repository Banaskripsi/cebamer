import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/add_opsional_pembiayaan.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/add_pembiayaan.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/controller/pembiayaan_controller.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/daftar_opsional_pembiayaan.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/daftar_pembiayaan.dart';
import 'package:cebamer/halaman/2/Ekonomi/pembiayaan/widget/chart_opsional_pembiayaan.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class EkonomiMain extends StatefulWidget {
  const EkonomiMain({super.key});

  @override
  State<EkonomiMain> createState() => _EkonomiMainState();
}

class _EkonomiMainState extends State<EkonomiMain> {
  final controller = Get.find<PembiayaanController>();

  @override
  void initState() {
    super.initState();
    // Pastikan data pembiayaan opsional ter-load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.lahan != null && controller.periode != null) {
        controller.listenPembiayaanOpsional();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ekonomi dan Biaya',
          style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: primer3)
        ),
      ),
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              j30,
              Text(
                'Input Data Pembiayaan',
                style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: primer3
                )
              ), j10,
              Text(
                'Fitur yang dapat Anda manfaatkan sebagai catatan keuangan dalam mengelola lahan, seperti pengeluaran, pemasukan, ambang batas ekonomi, dan lain-lain.'
              ), j10,
              divider(context, 'Fitur-fitur'), j20,
              GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 10,
                ),
                children: [
                  InkWell(
                    onTap: () => Get.to(() => UpDataPembiayaan()),
                    child: Container(
                      decoration: BoxDecoration(
                        color: warnaCerah3,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: aksenMerah)
                      ),
                      child: Padding(
                        padding: paddingLR20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.money_off_csred_outlined, size: 100, color: aksenMerah),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Pengeluaran ',
                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                                children: [
                                  TextSpan(
                                    text: 'Tetap',
                                    style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: aksenMerah),
                                  )
                                ]
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.to(() => PembiayaanOpsional()),
                    child: Container(
                      decoration: BoxDecoration(
                        color: warnaCerah3,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: aksenOranye)
                      ),
                      child: Padding(
                        padding: paddingLR20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Remix.refund_2_line, size: 100, color: aksenOranye),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Pengeluaran ',
                                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                                children: [
                                  TextSpan(
                                    text: 'Berkala',
                                    style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: aksenOranye),
                                  )
                                ]
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ), j10,
              divider(context, 'Diagram'), j20,
              // Pie Chart untuk Pembiayaan Opsional
              Obx(() {
                final daftar = controller.daftarBiaya;
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (daftar.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada data pengeluaran berkala',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan pengeluaran berkala untuk melihat diagram',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return PieChartSemuaPembiayaanTetap(daftarPembiayaan: daftar);
              }),
              j20,
              Obx(() {
                final daftar = controller.daftarBiayaOpsional;
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (daftar.isEmpty) {
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada data pengeluaran berkala',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan pengeluaran berkala untuk melihat diagram',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return PieChartSemuaPembiayaanOpsional(daftarPembiayaan: daftar);
              }), j20,
              divider(context, 'Daftar Pengeluaran'), j20,
              Card(
                color: primer1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  onTap: () => Get.to(() => DaftarOpsionalPembiayaan()),
                  leading: CircleAvatar(
                    backgroundColor: primer3,
                    child: Icon(
                      Remix.list_check_2,
                      color: warnaCerah3
                    ),
                  ),
                  title: Text(
                    'Daftar Pengeluaran Berkala',
                    style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: warnaCerah3)
                  ),
                ),
              ),
              j10,
              Card(
                color: primer1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                child: ListTile(
                  onTap: () => Get.to(() => DaftarPembiayaan()),
                  leading: CircleAvatar(
                    backgroundColor: primer3,
                    child: Icon(
                      Remix.list_check_2,
                      color: warnaCerah3
                    ),
                  ),
                  title: Text(
                    'Pengeluaran Tetap',
                    style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: warnaCerah3)
                  ),
                ),
              ),
              j30,
            ]
          ),
        ),
      )
    );
  }
}