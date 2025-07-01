import 'package:cebamer/halaman/2/features_main.dart';
import 'package:cebamer/halaman/3/pengaturan.dart';
import 'package:cebamer/halaman/beranda/beranda.dart';
import 'package:cebamer/routes/baritem_navigasi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'barnavigasi_controller.dart';

class Barnavigasi extends GetView<BarnavigasiController> {
  const Barnavigasi({super.key});


  static final List<Widget> _halaman = [
    const Beranda(),
    const FeaturesScreen(),
    const Pengaturan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Obx(() =>
        Baritem(
          onTapYoPora: controller.changePage,
          index: controller.selectedIndex.value,
          ),
      ),
      body: Obx(() => _halaman[controller.selectedIndex.value]),

      // Alternatif Body dengan IndexedStack untuk menjaga state halaman anak:
      // body: Obx(() => IndexedStack(
      //   index: controller.selectedIndex.value,
      //   children: _halaman,
      // )),
    );
  }
}