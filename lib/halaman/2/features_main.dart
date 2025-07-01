import 'package:cebamer/const/padding.dart';
import 'package:cebamer/const/sizedbox.dart';
import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';
import 'features_controller.dart';

class FeaturesScreen extends GetView<FeaturesController> {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primer1,
        title: Obx(() {
          if (controller.isLoadingLahan.value) {
            return Text('Memuat lahan ...', style: BanaTemaTeks.temaCerah.labelLarge!.copyWith(color: primer3));
          }
          final lahanAktif = controller.selectedLahanCtrl.lahanTerpilih;
          if (lahanAktif == null) {
            return Text('Tidak ada lahan', style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: Colors.white));
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lahan Aktif:', style: BanaTemaTeks.temaCerah.titleMedium!.copyWith(color: Colors.white70)),
              Text(lahanAktif.namaLahan, style: BanaTemaTeks.temaCerah.titleLarge!.copyWith(color: primer3))
            ],
          );
        }),
        actions: [
          IconButton(
            onPressed: controller.navigasiKeTambahLahan,
            icon: const Icon(Icons.add),
          )
        ],
        leading: Obx(() {
          final daftarLahan = controller.selectedLahanCtrl.daftarLahan;
          if (controller.isLoadingLahan.value || daftarLahan.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(15),
              child: Icon(Icons.error_outline),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MenuAnchor(
                builder: (context, menuController, child) {
                  return IconButton(
                    onPressed: () {
                      if (menuController.isOpen) {
                        menuController.close();
                      } else {
                        menuController.open();
                      }
                    },
                    icon: const Icon(Icons.sort),
                  );
                },
                menuChildren: daftarLahan.map((lahan) {
                  final lahanAktif = controller.selectedLahanCtrl.lahanTerpilih;
                  bool isSelected = lahan.id == lahanAktif?.id;
                  return MenuItemButton(
                    style: MenuItemButton.styleFrom(
                      backgroundColor: isSelected ? primer1.withOpacity(0.7) : null,
                      foregroundColor: isSelected ? Colors.white : null,
                    ),
                    onPressed: () => controller.onLahanPilih(lahan),
                    child: Text(lahan.namaLahan),
                  );
                }).toList()),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoadingLahan.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final lahanAktif = controller.selectedLahanCtrl.lahanTerpilih;
        final daftarLahan = controller.selectedLahanCtrl.daftarLahan;

        if (lahanAktif == null && !controller.isLoadingLahan.value) {
          return Center(
            child: Padding(
              padding: paddingLR20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.landscape_outlined, size: 80, color: primer1.withOpacity(0.7)),
                  j20,
                  Text(
                    daftarLahan.isEmpty
                        ? 'Anda belum menambahkan lahan. Silahkan tambahkan lahan baru.'
                        : 'Silakan pilih lahan dari menu pada bagian kiri atas untuk melanjutkan.',
                    textAlign: TextAlign.center,
                  ),
                  j20,
                  if (daftarLahan.isEmpty)
                    ElevatedButton.icon(
                        icon: const Icon(Icons.add_location_alt_outlined),
                        label: const Text('Tambahkan Lahan'),
                        onPressed: controller.navigasiKeTambahLahan,
                    )
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: paddingLR20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                j20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FITUR APLIKASI', style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3)),
                    j5,
                    Text(
                      'Beberapa fitur aplikasi yang dapat Anda gunakan sebagai media untuk membantu membudidayakan bawang merah dan meningkatkan produktivitas lahan.',
                      style: BanaTemaTeks.temaCerah.displaySmall!.copyWith(color: primer3),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
                j20,
                Padding(
                  padding: paddingLR20,
                  child: Row(
                    children: [
                      const Expanded(child: Divider(endIndent: 10, indent: 0)),
                      Text('Fungsionalitas', style: TextStyle(color: primer3.withOpacity(0.8))),
                      const Expanded(child: Divider(endIndent: 0, indent: 10))
                    ],
                  ),
                ),
                j30,
                Padding(
                  padding: paddingLR40,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildUIFeatures(
                          icon: Remix.search_eye_fill,
                          label: 'Surveilensi OPT',
                          onTap: () => Get.toNamed('/surveilensiMain')),
                      _buildUIFeatures(
                          icon: Remix.seedling_fill,
                          label: 'Perlakuan',
                          onTap: () => Get.toNamed('/perlakuanMain')),
                      _buildUIFeatures(
                          icon: Remix.currency_fill,
                          label: 'Ekonomi',
                          onTap: () => Get.toNamed('/ekonomiMain')),
                      _buildUIFeatures(
                          icon: Remix.bar_chart_2_fill,
                          label: 'Manajemen',
                          onTap: () => Get.toNamed('/manajemenMain'))
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildUIFeatures({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primer2,
          boxShadow: [ // Tambah sedikit shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0,2),
            )
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45, color: warnaCerah3), // Ukuran ikon disesuaikan
            j10, // Sizedbox
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: warnaCerah3)),
            )
          ],
        ),
      ),
    );
  }
}