import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/halaman/beranda/edukasi/varietas/controller/varietas_controller.dart';
import 'package:cebamer/halaman/components/widget.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VarietasMain extends StatelessWidget {
  const VarietasMain({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VarietasController());
    return Scaffold(
      backgroundColor: warnaCerah2,
      body: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Image.asset('assets/image/varietas.jpg', fit: BoxFit.cover))
              ),
            ),
          Positioned.fill(
            top: MediaQuery.of(context).size.aspectRatio * 550,
            child: Obx(()
              => Padding(
                padding: paddingLR20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Varietas bawang merah',
                      style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                    ), j5,
                    Text(
                      'Beberapa varietas bawang merah yang dapat Anda pertimbangkan untuk digunakan.',
                      style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3),
                    ), j10,
                    divider(context, 'Daftar Varietas'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.daftarVarietas.length,
                        itemBuilder: (context, index) {
                          final item = controller.daftarVarietas[index];
                          return Card(
                            color: warnaCerah3,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.namaVarietas!,
                                    style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3),
                                  ), j10,
                                  Table(
                                    columnWidths: const {
                                      0: IntrinsicColumnWidth(),
                                      1: FixedColumnWidth(10),
                                      2: FlexColumnWidth(),
                                    },
                                    defaultVerticalAlignment: TableCellVerticalAlignment.top,
                                    children: item.deskripsi!.entries.map((entry) {
                                      return TableRow(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Text(
                                              entry.key,
                                              style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: primer3),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Text(
                                              ' : ',
                                              style: BanaTemaTeks.temaCerah.displayMedium!.copyWith(color: primer3),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Text(
                                              '${entry.value}.',
                                              style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  )
                                ],
                              ),
                            )
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}