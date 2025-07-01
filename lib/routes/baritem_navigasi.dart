import 'package:cebamer/helper/banahelper.dart';
import 'package:cebamer/routes/barnavigasi_controller.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class Baritem extends GetView<BarnavigasiController> {
  final dynamic Function(int)? onTapYoPora;
  final int index;

  const Baritem({super.key, required this.onTapYoPora, required this.index});

  @override
  Widget build(BuildContext context) {
    final dark = Banahelper.modeGelap(context);

    return BottomNavigationBar(
      iconSize: 21,
      selectedItemColor: dark ? warnaCerah3 : primer2,
      unselectedItemColor: dark ? warnaCerah1 : Colors.blueGrey,
      selectedFontSize: 13,
      unselectedFontSize: 11,
      selectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      onTap: (value) => onTapYoPora!(value),
      currentIndex: index,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Remix.home_3_line),
            activeIcon: Icon(Remix.home_3_fill),
            label: 'Beranda'),
        BottomNavigationBarItem(
            icon: Icon(Remix.plant_line),
            activeIcon: Icon(Remix.plant_fill),
            label: 'Features'),
        BottomNavigationBarItem(
            icon: Icon(Remix.settings_2_line),
            activeIcon: Icon(Remix.settings_2_fill),
            label: 'Pengaturan')
      ],
    );
  }
}