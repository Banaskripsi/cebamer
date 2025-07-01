import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/beranda/edukasi/budidaya_controller.dart';
import 'package:cebamer/halaman/beranda/edukasi/budidaya/controller/materi_controller.dart';
import 'package:cebamer/halaman/beranda/edukasi/budidaya/materi.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/services/notifikasi.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class BudidayaMain extends StatefulWidget {
  const BudidayaMain({super.key});

  @override
  State<BudidayaMain> createState() => _BudidayaMainState();
}

class _BudidayaMainState extends State<BudidayaMain> {
  final controller = Get.put(BudidayaController());
  final materiController = Get.put(MateriController());

  List<IconData> icon = [
    Symbols.front_loader,
    Symbols.agriculture,
    Symbols.nutrition,
    Symbols.potted_plant,
    Symbols.eco,
    Symbols.sprinkler
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBG1,
      body: Obx(() {
        final sortedMateri = List.from(materiController.daftarMateri)
        ..sort((a, b) {
          final aTime = a.createdAt?.toDate();
          final bTime = b.createdAt?.toDate();
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return aTime.compareTo(bTime);
        });
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Image.asset('assets/image/budidaya1.jpg', fit: BoxFit.cover))
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.aspectRatio * 550,
              child: Padding(
                padding: paddingLR20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edukasi Budidaya Pertanian',
                      style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3)
                    ), j10,
                    Text(
                      'Isi materi berkaitan dengan langkah dan tindakan yang tepat untuk melakukan budidaya bawang merah.',
                      style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3)
                    ),
                     j30,
                    divider(context, 'Materi'),
                    // MATERI 1
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: sortedMateri.length,
                      itemBuilder: (context, index) {
                        final item = sortedMateri[index];
                        return Card(
                          color: primer1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            onTap: () => Get.to(() => MateriEdukasi(materi: item)),
                            leading: Icon(
                              index < icon.length ? icon[index] : Icons.help,
                              color: primer3,
                              size: 32
                            ),
                            title: Text(
                              item.headerJudul!,
                              style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                            ),
                            trailing: Icon(Icons.arrow_right)
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          DialogGlobal().tampilkan(title: 'Sumber Pustaka', message: 'Pusat Perpustakaan dan Penyebaran Teknologi Pertanian. 2017. Bertanam Bawang Merah tak Kenal Musim. Jakarta, IAARD PRESS.');
        },
        icon: Icon(Symbols.info),
        label: Text('Sumber Pustaka'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
      )
    );
  }
}