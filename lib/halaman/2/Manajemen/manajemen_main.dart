import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/data&fitur/cuaca/cuaca_page.dart';
import 'package:cebamer/data&fitur/kalender/kalender.dart';
import 'package:cebamer/halaman/2/Manajemen/A_Pekerjaan/tindakan_main.dart';
import 'package:cebamer/halaman/2/Manajemen/controller/manajemen_controller.dart';
import 'package:cebamer/halaman/2/Manajemen/petaLahan/manajemen_peta.dart';
import 'package:cebamer/halaman/2/Manajemen/pengaturanlahan/manajemen_settings.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class ManajemenMain extends StatelessWidget {
  const ManajemenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManajemenController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: primer1,
          body: Stack(
            children: [
              Positioned(
                top: 50,
                left: 0,
                child: Padding(
                  padding: paddingLR20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Lahan: ', style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: Colors.white)),
                      Text(
                        controller.lahan!.namaLahan,
                        style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)
                      ), j5,
                      SizedBox(
                        width: 300,
                        child: Text(
                          controller.lahan!.deskripsi!,
                          maxLines: 4,
                          overflow:TextOverflow.ellipsis,
                          style: TextStyle(fontStyle: FontStyle.italic,),
                          textAlign: TextAlign.justify,
                      ))
                    ],
                  ),
                )
              ),
              Positioned(
                top: 50,
                right: 0,
                child: Padding(
                  padding: paddingLR20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Get.to(() => ManajemenPeta()),
                        icon: Icon(Icons.map_outlined, size: 30),
                      ), j10,
                      IconButton(
                        onPressed: () => Get.to(() => ManajemenSettings()),
                        icon: Icon(Icons.settings_outlined, size: 30),
                      ), j10,
                      IconButton(
                        onPressed: () => controller.refreshData(),
                        icon: Icon(Icons.refresh, size: 30),
                      ),
                    ],
                  ),
                )
              ),
              Positioned.fill(
                top: 230,
                bottom: 0,
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    color: scaffoldBG1
                  ),
                  child: Padding(
                    padding: paddingLR20,
                    child: ListView(
                      children: [
                        Text(
                          'Informasi Umum',
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic)
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: CuacaPage(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  j5,
                                  Text(
                                    'Target Panen: ',
                                    style: BanaTemaTeks.temaCerah.labelLarge!.copyWith(color: primer1)
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: controller.periode!.targetPanen.toString(),
                                      style: BanaTemaTeks.temaCerah.headlineSmall!.copyWith(color: primer3),
                                      children: [
                                        TextSpan(
                                          text: ' Kg',
                                          style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
                                        )
                                      ]
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  j5,
                                  Text(
                                    'Luas Lahan: ',
                                    style: BanaTemaTeks.temaCerah.labelLarge!.copyWith(color: primer1)
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: controller.lahan!.luasLahan.toStringAsFixed(1),
                                      style: BanaTemaTeks.temaCerah.headlineSmall!.copyWith(color: primer3),
                                      children: [
                                        TextSpan(
                                          text: ' m²',
                                          style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
                                        )
                                      ]
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        j30,
                        Text(
                          'Pengelolaan Lahan',
                          style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3, fontStyle: FontStyle.italic)
                        ), j20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(() => KalenderPage()),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: primer2,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Remix.calendar_2_fill, size: MediaQuery.of(context).size.aspectRatio * 150, color: warnaCerah3), j5,
                                    Text(
                                      'Kalender',
                                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: warnaCerah3)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(() => TindakanMain()),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: primer2,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Remix.tools_fill, size: MediaQuery.of(context).size.aspectRatio * 150, color: warnaCerah3), j5,
                                    Text(
                                      'Pekerjaan',
                                      style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: warnaCerah3)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        j50
                      ],
                    ),
                  )
                ),
              ),
            ],
          )
        );
      },
    );
  }
}