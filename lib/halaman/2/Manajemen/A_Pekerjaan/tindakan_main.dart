import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/controller/tindakan_controller.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/widget/tindakan_add.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

class TindakanMain extends StatefulWidget {
  const TindakanMain({super.key});

  @override
  State<TindakanMain> createState() => _TindakanMainState();
}

class _TindakanMainState extends State<TindakanMain> {
  final controller = Get.find<TindakanController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingLR20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              j50,
              header(context, judul: 'Tindakan', deskripsi: 'Anda dapat menambahkan data tindakan, sebagai pengingat dan catatan.'),
              j30,
              divider(context, 'Daftar Tindakan'),
              Obx(() {
                if (controller.daftarTindakan.isEmpty) {
                  return Center(child: Text('Belum ada data tindakan untuk ditampilkan, silahkan tambahkan terlebih dahulu.'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.daftarTindakan.length,
                  itemBuilder: (context, index) {
                    final tindakan = controller.daftarTindakan[index];
                    return Obx(() {
                      final isExpanded = controller.isExpanded(tindakan.id!);
                      return Card(
                        color: aksenNavy,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: aksenNavy
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tindakan.namaProduk,
                                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: warnaCerah3),
                                          ), j5,
                                          Text(
                                            DateFormat.yMMMd('id_ID').format(tindakan.tanggalAplikasi),
                                            style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer1),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => controller.deleteTindakan(tindakan.id!),
                                          icon: Icon(Icons.delete, color: salahInd),
                                          style: IconButton.styleFrom(
                                            backgroundColor: warnaCerah3)
                                        ),
                                        IconButton(
                                          onPressed: () => controller.toggleExpanded(tindakan.id!),
                                          icon: Icon(
                                            isExpanded 
                                              ? Remix.arrow_up_s_fill 
                                              : Remix.arrow_down_s_fill,
                                            color: warnaCerah3,
                                          ),
                                          style: IconButton.styleFrom(
                                            backgroundColor: primer1,
                                          )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                if (isExpanded) ...[
                                  j10,
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: primer1.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Deskripsi:',
                                              style: BanaTemaTeks.temaCerah.bodySmall!.copyWith(
                                                color: primer1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            j5,
                                            Text(
                                              tindakan.deskripsi?.isNotEmpty == true 
                                                ? tindakan.deskripsi! 
                                                : 'Tidak ada deskripsi',
                                              style: BanaTemaTeks.temaCerah.bodySmall!.copyWith(
                                                color: warnaCerah3,
                                              ),
                                            ),
                                            j5,
                                            Text(
                                              'Penyebab:',
                                              style: BanaTemaTeks.temaCerah.bodySmall!.copyWith(
                                                color: primer1,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              tindakan.penyebab.isNotEmpty == true
                                                ? tindakan.penyebab 
                                                : 'Tidak diketahui',
                                              style: BanaTemaTeks.temaCerah.bodySmall!.copyWith(
                                                color: warnaCerah3,
                                              ),
                                            ),
                                            j5,
                                          ],
                                        ),
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: warnaCerah3,
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                text: tindakan.aplikasiProduk.toStringAsFixed(0),
                                                style: BanaTemaTeks.temaCerah.headlineMedium!.copyWith(color: primer3),
                                                children: [
                                                  TextSpan(
                                                    text: ' Kg',
                                                    style: BanaTemaTeks.temaCerah.bodySmall!.copyWith(color: primer3)
                                                  )
                                                ]
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        )
                      );
                    });
                  },
                );
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primer2,
        onPressed: () => Get.to(() => TindakanAdd()),
        child: Icon(Remix.add_circle_fill, color: warnaCerah3,),
      ),
    );
  }
}